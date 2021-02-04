#!/bin/bash
#
# Copyright 2021 "Holloway" Chew, Kean Ho <hollowaykeanho@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.




# configure project variables
export REGION="us-central1"
export ZONE="us-central1-c"
export PROJECT="$(gcloud config get-value project)"
gcloud config set compute/region "$REGION"
gcloud config set compute/zone "$ZONE"




# create cluster
export CLUSTER="kraken-cluster"
export CLUSTER_NODES="2"
export CLUSTER_MACHINE_TYPE="n1-standard-4"
gcloud container clusters create "$CLUSTER" \
	--zone "$ZONE" \
	--num-nodes "$CLUSTER_NODES" \
	--machine-type "$CLUSTER_MACHINE_TYPE" \
	--enable-network-policy




# create SQL database
export SQL="kraken-sql"
export SQL_AVAILABILITY="regional"
export SQL_VERSION="MYSQL_8_0"
export SQL_TIER="db-n1-standard-1"
export SQL_ROOT_PASSWORD="${SQL_ROOT_PASSWORD:-"myR0()Ttesting123"}"
gcloud sql instances create "$SQL" \
	--availability-type "$SQL_AVAILABILITY" \
	--backup \
	--database-version "$SQL_VERSION" \
	--tier "$SQL_TIER" \
	--root-password "$SQL_ROOT_PASSWORD" \
	--enable-bin-log \
	--region "$REGION"

## create database
export WP_DATABASE="wordpress"
gcloud sql databases create "$WP_DATABASE" --instance="$SQL"

## create database admin user account
export WP_ADMIN="admin"
export WP_SQL_ADMIN_PASSWORD="${WP_SQL_ADMIN_PASSWORD:-"wordpress-sql-@d1|n"}"
gcloud sql users create "$WP_ADMIN" \
	--instance="$SQL" \
	--host=% \
	--password="$WP_SQL_ADMIN_PASSWORD"

## create database workpress service user account
export WP_SQL_ACC="wordpress"
export WP_SQL_ACC_PASSWORD="${WP_SQL_ACC_PASSWORD:-"wordpress-sql-p@55"}"
gcloud sql users create "$WP_SQL_ACC" \
	--instance="$SQL" \
	--host=% \
	--password="$WP_SQL_ACC_PASSWORD"

### save wordpress sql account credentials as secret in k8s cluster
kubectl create secret generic cloudsql-db-credentials \
	--from-literal "username=$WP_SQL_ACC" \
	--from-literal "password=$WP_SQL_ACC_PASSWORD"




# create Wordpress
export SERVICE_ACCOUNT="kraken-services"
export SERVICE_EMAIL="${SERVICE_ACCOUNT}@${PROJECT}.iam.gserviceaccount.com"
export SERVICE_ACCOUNT_KEYFILE="key.json"
gcloud iam service-accounts create "$SERVICE_ACCOUNT"
gcloud projects add-iam-policy-binding "$PROJECT" \
	--member="serviceAccount:${SERVICE_EMAIL}" \
	--role="roles/cloudsql.client"
gcloud iam service-accounts keys create "$SERVICE_ACCOUNT_KEYFILE" \
	--iam-account="$SERVICE_EMAIL"
kubectl create secret generic cloudsql-instance-credentials \
	--from-file "$SERVICE_ACCOUNT_KEYFILE"

## create persistent volume
cat << EOF | kubectl create -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: wordpress-volumeclaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 200Gi
EOF

## create wordpress
cat << EOF | kubectl create -f -
apiVersion: v1
kind: Service
metadata:
  labels:
    app: wordpress
  name: wordpress
spec:
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
  selector:
    app: wordpress
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
        - image: wordpress
          name: wordpress
          env:
          - name: WORDPRESS_DB_HOST
            value: 127.0.0.1:3306
          # These secrets are required to start the pod.
          - name: WORDPRESS_DB_USER
            valueFrom:
              secretKeyRef:
                name: cloudsql-db-credentials
                key: username
          - name: WORDPRESS_DB_PASSWORD
            valueFrom:
              secretKeyRef:
                name: cloudsql-db-credentials
                key: password
          ports:
            - containerPort: 80
              name: wordpress
          volumeMounts:
            - name: wordpress-persistent-storage
              mountPath: /var/www/html
        - name: cloudsql-proxy
          image: gcr.io/cloudsql-docker/gce-proxy:1.11
          command: ["/cloud_sql_proxy",
                    "-instances=${PROJECT}:${REGION}:${SQL}=tcp:3306",
                    # If running on a VPC, the Cloud SQL proxy can connect via Private IP. See:
                    # https://cloud.google.com/sql/docs/mysql/private-ip for more info.
                    # "-ip_address_types=PRIVATE",
                    "-credential_file=/secrets/cloudsql/key.json"]
          securityContext:
            runAsUser: 2  # non-root user
            allowPrivilegeEscalation: false
          volumeMounts:
            - name: cloudsql-instance-credentials
              mountPath: /secrets/cloudsql
              readOnly: true
      volumes:
        - name: wordpress-persistent-storage
          persistentVolumeClaim:
            claimName: wordpress-volumeclaim
        - name: cloudsql-instance-credentials
          secret:
            secretName: cloudsql-instance-credentials
EOF




# setup ingress with TLS
export RELEASE_NAME="nginx-ingress"
helm repo add stable https://charts.helm.sh/stable # outdated but required
##! BUG (supposedly): $ helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install nginx-ingress stable/nginx-ingress # outdated but required
##! BUG (supposedly): $ helm install "$RELEASE_NAME" nginx-stable/nginx-ingress

## Setup DNS Record
kubectl get svc
### check external IP readiness before proceed to next step
kubectl get service nginx-ingress-controller
### BUG:    fix that damm bug inside add_ip.sh to echo $USER_NAME instead of
###         $USER which can be fatal for TLS generation stage.
./add_ip.sh
export TLS_DNS="student00ca5437b21809.labdns.xyz" # this format was added

## install cert manager
export TLS_MANAGER_VERSION="v1.1.0"
export TLS_MANAGER_URL="https://github.com/jetstack/cert-manager/releases/download/"
kubectl apply -f "${TLS_MANAGER_URL}/${TLS_MANAGER_VERSION}/cert-manager.yaml"

## apply TLS issuer
export TLS_EMAIL="$SERVICE_EMAIL"
cat << EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1alpha2
kind: Issuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: $TLS_EMAIL
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    # Enable the HTTP-01 challenge provider
    solvers:
    - http01:
        ingress:
          class: nginx
EOF

## configure ingress to use encrypted certificate
cat << EOF | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: wordpress
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts:
    - $TLS_DNS
    secretName: wordpress-tls
  rules:
  - host: $TLS_DNS
    http:
      paths:
      - path: /
        backend:
          serviceName: wordpress
          servicePort: 80
EOF




# setup network policy
cat << EOF | kubectl apply -f -
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: default-deny-all-ingress
  namespace: default
spec:
  podSelector:
    matchLabels: {}
  policyTypes:
  - Ingress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-nginx-access-to-wordpress
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: wordpress
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: nginx-ingress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-nginx-access-to-internet
spec:
  podSelector:
    matchLabels:
      app: nginx-ingress
  policyTypes:
  - Ingress
  ingress:
  - {}
EOF




# setup binary authorization
## 1. update binauthz via GUI
## 2. update cluster to enable binary authorization (takes time)
gcloud container clusters update "$CLUSTER" --zone "$ZONE" --enable-binauthz




# setup pod security policy
## set role
cat << EOF | kubectl apply -f -
---
    # All service accounts in kube-system
    # can 'use' the 'permissive-psp' PSP
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: restrictive-psp
      namespace: default
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: restrictive-psp
    subjects:
    - apiGroup: rbac.authorization.k8s.io
      kind: Group
      name: system:authenticated
EOF

## set use
cat << EOF | kubectl apply -f -
---
    kind: ClusterRole
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: restrictive-psp
    rules:
    - apiGroups:
      - extensions
      resources:
      - podsecuritypolicies
      resourceNames:
      - restrictive-psp
      verbs:
      - use
EOF

## set restrictive
## FIXBUG: change the apiVersion to 'policy/v1beta1' from the already
##         deprecated version 'extensions/v1beta1'. Otherwise, you can't apply
##         the settings.
cat << EOF | kubectl apply -f -
---
    apiVersion: policy/v1beta1
    kind: PodSecurityPolicy
    metadata:
      name: restrictive-psp
      annotations:
        seccomp.security.alpha.kubernetes.io/allowedProfileNames: 'docker/default'
        apparmor.security.beta.kubernetes.io/allowedProfileNames: 'runtime/default'
        seccomp.security.alpha.kubernetes.io/defaultProfileName:  'docker/default'
        apparmor.security.beta.kubernetes.io/defaultProfileName:  'runtime/default'
    spec:
      privileged: false
      # Required to prevent escalations to root.
      allowPrivilegeEscalation: false
      # This is redundant with non-root + disallow privilege escalation,
      # but we can provide it for defense in depth.
      requiredDropCapabilities:
        - ALL
      # Allow core volume types.
      volumes:
        - 'configMap'
        - 'emptyDir'
        - 'projected'
        - 'secret'
        - 'downwardAPI'
        # Assume that persistentVolumes set up by the cluster admin are safe to use.
        - 'persistentVolumeClaim'
      hostNetwork: false
      hostIPC: false
      hostPID: false
      runAsUser:
        # Require the container to run without root privileges.
        rule: 'MustRunAsNonRoot'
      seLinux:
        # This policy assumes the nodes are using AppArmor rather than SELinux.
        rule: 'RunAsAny'
      supplementalGroups:
        rule: 'MustRunAs'
        ranges:
          # Forbid adding the root group.
          - min: 1
            max: 65535
      fsGroup:
        rule: 'MustRunAs'
        ranges:
          # Forbid adding the root group.
          - min: 1
            max: 65535
EOF
