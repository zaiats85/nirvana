K8S_CERT-MANAGER_NAMESPACE ?= cert-manager
K8S_CERT-MANAGER_VERSION ?= v1.7.1

.PHONY: k8s/cert-manager/setup
k8s/cert-manager/setup:
	helm repo add jetstack https://charts.jetstack.io
	helm repo update

.PHONY: k8s/cert-manager/install
k8s/cert-manager/install:
	helm upgrade --install cert-manager jetstack/cert-manager --namespace $(K8S_CERT-MANAGER_NAMESPACE) --version $(K8S_CERT-MANAGER_VERSION) --set installCRDs=true

.PHONY: k8s/cert-manager/setup-issuer
k8s/cert-manager/setup-issuer:
	kubectl create --namespace $(K8S_CERT-MANAGER_NAMESPACE) --edit -f https://cert-manager.io/docs/tutorials/acme/example/production-issuer.yaml
