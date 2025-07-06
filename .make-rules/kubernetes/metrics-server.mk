K8S_METRICS-SERVER_NAMESPACE ?= kube-system

.PHONY: k8s/metrics-server/setup
k8s/metrics-server/setup:
	helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
	helm repo update

.PHONY: k8s/metrics-server/install
k8s/metrics-server/install:
	helm upgrade --install metrics-server metrics-server/metrics-server --namespace $(K8S_METRICS-SERVER_NAMESPACE)

.PHONY: metrics-server/kubelet-insecure-tls
k8s/metrics-server/kubelet-insecure-tls:
	kubectl patch --namespace kube-system deployment metrics-server --type json -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/-","value": "--kubelet-insecure-tls"}]'