TIMESTAMP ?= $$(date +%s)
PROJECT_NAME ?= flagbit
EVENT_NAME ?= deployment
GRAFANA_PROJECT_ENVIRONMENT ?= $(EVENT_NAME)
GRAFANA_PROJECT_NAME ?= $(PROJECT_NAME)
GRAFANA_ANNOTATION_MESSAGE ?= $(EVENT_NAME)

#
# Examples:
#
#   make grafana/annotation/deployment
#   make grafana/annotation/setup GRAFANA_PROJECT_ENVIRONMENT=production
# ==============================================================================
.PHONY: grafana/annotation/%
grafana/annotation/%:
	curl -X POST -H "Content-Type: application/json" \
	-H "Authorization: Bearer $(GRAFANA_TOKEN)" \
	-d "{\"when\":$(TIMESTAMP),\"tags\":[\"$(GRAFANA_PROJECT_ENVIRONMENT)\",\"$(GRAFANA_PROJECT_NAME)\",\"$(@F)\"],\"what\": \"$(GRAFANA_ANNOTATION_MESSAGE)\"}" \
	"$(GRAFANA_URL)/api/annotations/graphite"
