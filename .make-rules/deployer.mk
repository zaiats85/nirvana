DEPLOYER_BIN ?= dep

.PHONY: deploy/%
deploy/%:
	@echo Deploying to $(@F) system
	$(DEPLOYER_BIN) deploy $(@F)

.PHONY: deploy-rollback/%
deploy-rollback/%:
	@echo Deploying to $(@F) system
	$(DEPLOYER_BIN) rollback $(@F)
