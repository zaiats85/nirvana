.PHONY: k8s/create-dockerconfig
k8s/create-dockerconfig:
	kubectl create --namespace $(K8S_NAMESPACE) secret generic $(IMAGE_PULL_SECRET) --from-literal=.dockerconfigjson='$(DOCKERCONFIGJSON)' --type=kubernetes.io/dockerconfigjson

.PHONY: k8s/patch-serviceaccount
k8s/patch-serviceaccount:
	kubectl patch --namespace $(K8S_NAMESPACE) serviceaccount default -p '{"imagePullSecrets": [{"name": "$(IMAGE_PULL_SECRET)"}]}'