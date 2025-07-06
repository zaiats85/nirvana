K8S_INGRESS-CONTROLLER_NAMESPACE ?= ingress-controller

.PHONY: k8s/ingress-controller/setup
k8s/ingress-controller/setup:
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo update

.PHONY: k8s/ingress-controller/install
k8s/ingress-controller/install:
	helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace $(K8S_INGRESS-CONTROLLER_NAMESPACE)