PACKER := packer
SECRETS := -var-file secrets.pkrvars.hcl
DEB11 := debian11.pkr.hcl

all: debian11

init:
	packer init .

format:
	$(PACKER) fmt ./

debian11: template-900

template-900:
	$(PACKER) validate -var-file debian11.pkrvars.hcl ./
	$(PACKER) fmt ./
	$(PACKER) build -var-file debian11.pkrvars.hcl ./
