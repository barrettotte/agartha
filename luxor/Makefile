PACKER_DIR := packer
TERRAFORM_DIR := terraform

all: vm_templates

init:
	sudo ./install.sh
	$(MAKE) -C $(PACKER_DIR) init
	$(MAKE) -C $(TERRAFORM_DIR) init

provision:
	$(MAKE) -C $(TERRAFORM_DIR)
	echo 'Rerunning provision to ensure VMs are created.'

vm_templates:
	$(MAKE) -C $(PACKER_DIR) || true
	echo 'TODO: fix VM template via Ansible playbooks'

format:
	$(MAKE) -C $(PACKER_DIR) format
	$(MAKE) -C $(TERRAFORM_DIR) format

destroy:
	$(MAKE) -C $(TERRAFORM_DIR) destroy
	echo 'Note: Must manually delete VM templates.'
