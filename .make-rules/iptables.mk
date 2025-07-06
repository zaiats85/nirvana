IPTABLES_EXECUTABLES ?= iptables ip6tables

.PHONY: iptables/reset
iptables/reset:
	for iptables in $(IPTABLES_EXECUTABLES) ; do \
		sudo $$iptables --flush ; \
		sudo $$iptables --delete-chain ; \
	done

.PHONY: iptables/accept-loopback
iptables/accept-loopback:
	for iptables in $(IPTABLES_EXECUTABLES) ; do \
		sudo $$iptables -A INPUT -i lo -j ACCEPT ; \
		sudo $$iptables -A OUTPUT -o lo -j ACCEPT ; \
	done

.PHONY: iptables/drop-icmp
iptables/drop-icmp:
	for iptables in $(IPTABLES_EXECUTABLES) ; do \
		sudo $$iptables -A INPUT -p icmp --icmp-type any -j DROP ; \
		sudo $$iptables -A OUTPUT -p icmp -j DROP ; \
	done

.PHONY: iptables/accept-established
iptables/accept-established:
	for iptables in $(IPTABLES_EXECUTABLES) ; do \
		sudo $$iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT ; \
	done

.PHONY: iptables/default-policies
iptables/default-policies:
	for iptables in $(IPTABLES_EXECUTABLES) ; do \
		sudo $$iptables -P INPUT DROP ; \
		sudo $$iptables -P OUTPUT ACCEPT ; \
	done

.PHONY: iptables/accept/%
iptables/accept/%:
	for iptables in $(IPTABLES_EXECUTABLES) ; do \
		sudo $$iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport $(@F) -j ACCEPT ; \
	done

.PHONY: iptables/persist
iptables/persist:
	for iptables in $(IPTABLES_EXECUTABLES) ; do \
		sudo $$iptables-save | sudo tee /etc/iptables/$$iptables-rules ; \
	done

.PHONY: iptables/defaults
iptables/defaults: iptables/reset iptables/accept-loopback iptables/drop-icmp iptables/accept-established iptables/default-policies

.PHONY: iptables/only-ssh
iptables/only-ssh: iptables/defaults iptables/accept/22 iptables/persist

.PHONY: iptables/defaults-webserver
iptables/defaults-webserver: iptables/defaults iptables/accept/22 iptables/accept/80 iptables/accept/443 iptables/persist