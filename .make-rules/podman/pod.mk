CONTAINER_MANAGER ?= podman
PODNAME ?= changeme

pod/create:
	$(CONTAINER_MANAGER) pod create --name $(PODNAME) --userns=keep-id --publish 8080:8080

pod/start:
	$(CONTAINER_MANAGER) pod start $(PODNAME)

pod/stop:
	$(CONTAINER_MANAGER) pod stop $(PODNAME)

pod/rm:
	$(CONTAINER_MANAGER) pod rm $(PODNAME)

pod/rebuild: pod/stop pod/rm pod/init

pod/attach/%:
	$(CONTAINER_MANAGER) run -d --user $$UID --name=$(PODNAME)_$(@F) --pod=$(PODNAME) $(FQIN)
