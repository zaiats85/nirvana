.PHONY: k8s/delete-evicted-pods
k8s/delete-evicted-pods:
	kubectl get pods --all-namespaces|grep Evicted|awk '{system("kubectl -n "$$1" delete pod "$$2)}'

.PHONY: k8s/delete-completed-pods
k8s/delete-completed-pods:
	kubectl get pods --all-namespaces|grep Completed|awk '{system("kubectl -n "$$1" delete pod "$$2)}'

.PHONY: k8s/delete-error-pods
k8s/delete-error-pods:
	kubectl get pods --all-namespaces|grep Error|awk '{system("kubectl -n "$$1" delete pod "$$2)}'