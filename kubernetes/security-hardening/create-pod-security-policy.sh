#!/bin/bash




# 1. create restrictive policy
cat <<EOF | kubectl apply -f -
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




# 2. create role to use that policy
cat <<EOF | kubectl apply -f -
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




# 3. create role binding
cat <<EOF | kubectl apply -f -
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




# 4. enable pod security policy
gcloud beta container clusters update "$CLUSTER" \
	--zone "$ZONE" \
	--enable-pod-security-policy
