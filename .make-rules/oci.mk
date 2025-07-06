IMAGE_VERSION ?= $$(cat version.txt)
COMMIT_SHA ?= $$(git rev-parse --short HEAD)
BUILD_CONTEXT ?= .

.PHONY: oci/clean
oci/clean:
	$(CONTAINER_MANAGER) rmi $(FQIN):$(COMMIT_SHA)
	$(CONTAINER_MANAGER) rmi $(FQIN):$(IMAGE_VERSION)

.PHONY: oci/build
oci/build:
	$(CONTAINER_MANAGER) build \
	  -t $(FQIN):$(COMMIT_SHA) \
	  -t $(FQIN):$(IMAGE_VERSION) \
	  -f $(DOCKERFILE_PATH) \
	  $(BUILD_CONTEXT)

.PHONY: oci/build/%
oci/build/%:
	$(CONTAINER_MANAGER) build \
	  --target $(@F) \
	  -t $(FQIN):$(COMMIT_SHA) \
	  -t $(FQIN):$(IMAGE_VERSION) \
	  -f $(DOCKERFILE_PATH) \
	  $(BUILD_CONTEXT)

.PHONY: oci/push-commit
oci/push-commit:
	$(CONTAINER_MANAGER) push $(FQIN):$(COMMIT_SHA)

.PHONY: oci/push-release
oci/push-release:
	$(CONTAINER_MANAGER) push $(FQIN):$(IMAGE_VERSION)

.PHONY: oci/push
oci/push: oci/push-commit oci/push-release