SSH_AUTH_SOCK ?= /tmp/ssh_agent.sock

# required SHELL to be bash otherwise won't work
.PHONY: ssh/configure
ssh/configure:
	ssh-agent -a $(SSH_AUTH_SOCK) > /dev/null \
		&& SSH_AUTH_SOCK=$(SSH_AUTH_SOCK) ssh-add - <<< "$$SSH_PRIVATE_KEY"
