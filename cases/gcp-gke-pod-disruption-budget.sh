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

kubectl create poddisruptionbudget kube-dns-pdb \
	--namespace=kube-system \
	--selector k8s-app=kube-dns \
	--max-unavailable 1
kubectl create poddisruptionbudget prometheus-pdb \
	--namespace=kube-system \
	--selector k8s-app=prometheus-to-sd \
	--max-unavailable 1
kubectl create poddisruptionbudget kube-proxy-pdb \
	--namespace=kube-system \
	--selector component=kube-proxy \
	--max-unavailable 1
kubectl create poddisruptionbudget metrics-agent-pdb \
	--namespace=kube-system \
	--selector k8s-app=gke-metrics-agent \
	--max-unavailable 1
kubectl create poddisruptionbudget metrics-server-pdb \
	--namespace=kube-system \
	--selector k8s-app=metrics-server \
	--max-unavailable 1
kubectl create poddisruptionbudget fluentd-pdb \
	--namespace=kube-system \
	--selector k8s-app=fluentd-gke \
	--max-unavailable 1
kubectl create poddisruptionbudget backend-pdb \
	--namespace=kube-system \
	--selector k8s-app=glbc \
	--max-unavailable 1
kubectl create poddisruptionbudget kube-dns-autoscaler-pdb \
	--namespace=kube-system \
	--selector k8s-app=kube-dns-autoscaler \
	--max-unavailable 1
kubectl create poddisruptionbudget stackdriver-pdb \
	--namespace=kube-system \
	--selector app=stackdriver-metadata-agent \
	--max-unavailable 1
kubectl create poddisruptionbudget event-pdb \
	--namespace=kube-system \
	--selector k8s-app=event-exporter \
	--max-unavailable 1
