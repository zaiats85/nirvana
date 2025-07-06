K8S_MARIADB_NAMESPACE ?= mariadb
MARIADB_HELM_RELEASENAME ?= mariadb
MARIADB_HELM_CHART ?= bitnami/mariadb
MARIADB_ROOT_PASSWORD ?= password

.PHONY: helm/bitnami/setup
helm/bitnami/setup:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update

.PHONY: k8s/mariadb/install
k8s/mariadb/install:
	helm install --namespace $(K8S_MARIADB_NAMESPACE) --create-namespace $(MARIADB_HELM_RELEASENAME) $(MARIADB_HELM_CHART)

.PHONY: k8s/mariadb/delete
k8s/mariadb/delete:
	helm del --namespace $(K8S_MARIADB_NAMESPACE) $(MARIADB_HELM_RELEASENAME)

.PHONY: k8s/mariadb/get-root-password
k8s/mariadb/get-root-password:
	kubectl get secret --namespace $(K8S_MARIADB_NAMESPACE) $(MARIADB_HELM_RELEASENAME) -o jsonpath="{.data.mariadb-root-password}" | base64 --decode

.PHONY: k8s/mariadb/update
k8s/mariadb/update:
	helm upgrade mariadb bitnami/mariadb --set auth.rootPassword=$(MARIADB_ROOT_PASSWORD)
