K8S_NAMESPACES ?= develop production

.PHONY: k8s/namespaces-create
k8s/namespaces/create:
	for namespace in $(K8S_NAMESPACES); do \
		kubectl create namespace $$namespace ; \
	done

.PHONY: k8s/namespaces-delete
k8s/namespaces/delete:
	for namespace in $(K8S_NAMESPACES); do \
		kubectl delete namespace $$namespace ; \
	done