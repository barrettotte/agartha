TERRAFORM := terraform

all: provision

init:
	$(TERRAFORM) init

provision:
	$(TERRAFORM) validate
	$(TERRAFORM) plan
	$(TERRAFORM) apply -auto-approve -parallelism 3

format:
	$(TERRAFORM) fmt .
	$(TERRAFORM) fmt modules/*

destroy:
	$(TERRAFORM) destroy
