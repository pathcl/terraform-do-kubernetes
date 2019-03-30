.ONESHELL:
.SHELL :=bibash
.PHONY: install uninstall help config init plan apply destroy
CURRENT_FOLDER=$(shell basename "$$(pwd)")
DIR := ${CURDIR}

install: init plan apply ## Create plan and apply it

uninstall: destroy 	## Destroy everything

help: doc 		

config: init 		## install all dependencies you need

doc: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## Downloads providers for terraform
	@terraform init

plan:  ## Show what terraform thinks it will do
	@terraform plan 

all: lab dev testing acc prod

homero:	## Deploy lab cluster
	@terraform init
	@terraform apply -auto-approve -target module.kubernetes

destroyhomero:	## Deploy lab cluster
	@terraform init
	@terraform destroy -target module.kubernetes

