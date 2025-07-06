MYSQL_RUN ?= mysql

.PHONY: db/export
db/export:
	$(MYSQL_RUN) > $(file)

.PHONY: db/import
db/import:
	$(MYSQL_RUN) < $(file)

.PHONY: db/sql
db/sql:
	$(MYSQL_RUN) -e "$(sql)"
