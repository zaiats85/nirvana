.PHONY: %/deprecated
%/deprecated:
	@echo -e "\n\033[31mUsing $(@D) is deprecated!\nPlease take a look at the target to find an alternative!\033[0m\n"