K8S_HCLOUD_NAMESPACE ?= kube-system
HCLOUD_TOKEN ?=

.PHONY: k8s/hcloud/helm/init
k8s/hcloud/helm/init: k8s/hcloud/helm/setup k8s/hcloud/secret/create k8s/hcloud/helm/ccm/install k8s/hcloud/helm/csi/install

.PHONY: k8s/hcloud/helm/setup
k8s/hcloud/helm/setup:
	helm repo add hcloud https://charts.hetzner.cloud
	helm repo update hcloud

.PHONY: k8s/hcloud/secret/create
k8s/hcloud/secret/create:
	kubectl create secret generic hcloud \
		-n $(K8S_HCLOUD_NAMESPACE) \
		--from-literal=token=$(HCLOUD_TOKEN)

.PHONY: k8s/hcloud/helm/ccm/install
k8s/hcloud/helm/ccm/install:
	helm upgrade \
		--install hcloud-ccm \
		hcloud/hcloud-cloud-controller-manager \
		--namespace $(K8S_HCLOUD_NAMESPACE)

.PHONY: k8s/hcloud/helm/csi/install
k8s/hcloud/helm/csi/install:
	helm upgrade \
		--install hcloud-ccm \
		hcloud/hcloud-cloud-csi \
		--namespace $(K8S_HCLOUD_NAMESPACE)
