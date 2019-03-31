.ONESHELL:
.SHELL :=bibash
.PHONY: install uninstall help config init plan apply destroy
CURRENT_FOLDER=$(shell basename "$$(pwd)")
DIR := ${CURDIR}

help: doc

config: init 		## install all dependencies you need

doc:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## Downloads providers for terraform
	@terraform init

plan:  ## Show what terraform thinks it will do
	@terraform plan

all: kub prometheus homero covilha prom

kub:	## Deploy kubernetes cluster
	@terraform init
	@terraform apply -auto-approve -target module.kubernetes

destroykub:	## Destroy kubernetes cluster
	@terraform init
	@terraform destroy -target module.kubernetes

prometheus: ## Create prometheus server
	@terraform apply -auto-approve -target module.prometheus

destroyprom:	## Deploy prometheus server
	@terraform init
	@terraform destroy -target module.prometheus

homero: ## display homero! only tested on os x
	@open http://`dig +short homero.dev @ns1.digitalocean.com`/homerosimpson

covilha: ## display hour in covilha city
	@open http://`dig +short homero.dev @ns1.digitalocean.com`/covilha

prom: ## display prometheus
	@open http://`dig +short prom.homero.dev @ns1.digitalocean.com`:9090

clean: ## deletes everything
	@terraform destroy -auto-approve
