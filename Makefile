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
	@open http://k8s.sanmartin.dev/homerosimpson; sleep 5

covilha: ## display hour in covilha city
	@open http://k8s.sanmartin.dev/covilha; sleep 5

prom: ## display prometheus
	@open http://prom.sanmartin.dev:9090

clean: ## deletes everything
	@terraform destroy -auto-approve
