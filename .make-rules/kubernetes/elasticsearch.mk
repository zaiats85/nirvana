K8S_ELASTIC_NAMESPACE ?= elastic
ELASTICSEARCH_HELM_RELEASENAME ?= elasticsearch
ELASTICSEARCH_HELM_CHART ?= elastic/elasticsearch
ELASTICSEARCH_HELM_VALUES ?= .helm/elasticsearch/values.yaml

.PHONY: k8s/elastic/setup
k8s/elastic/setup:
	helm repo add elastic https://helm.elastic.co/
	helm repo update

.PHONY: k8s/elasticsearch/install
k8s/elasticsearch/install:
	helm install --namespace $(K8S_ELASTIC_NAMESPACE) $(ELASTICSEARCH_HELM_RELEASENAME) $(ELASTICSEARCH_HELM_CHART) --values $(ELASTICSEARCH_HELM_VALUES)

.PHONY: k8s/elasticsearch/delete
k8s/elasticsearch/delete:
	helm del --namespace $(K8S_ELASTIC_NAMESPACE) $(ELASTICSEARCH_HELM_RELEASENAME)
