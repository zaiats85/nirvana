DEPLOYER_BIN ?= dep
DEBUG ?= false

ifeq (false, $(DEBUG))
  VERBOSITY =
else
  VERBOSITY = -vvv
endif

.PHONY: deploy/%
deploy/%:
	@echo Deploying to $(@F) system
	$(DEPLOYER_BIN) deploy stage=$(@F) $(VERBOSITY)

.PHONY: deploy-rollback/%
deploy-rollback/%:
	@echo Aplaying rollback to $(@F) system
	$(DEPLOYER_BIN) rollback stage=$(@F) $(VERBOSITY)

.PHONY: deploy-unlock/%
deploy-unlock/%:
	@echo Removing deployment lock in $(@F) system
	$(DEPLOYER_BIN) deploy:unlock stage=$(@F)
