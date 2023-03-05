PACKER := packer
SECRETS := -var-file secrets.pkrvars.hcl
DEB11 := debian-11/debian-11.pkr.hcl

all: debian-11

debian-11: vm900

vm900:
	$(PACKER) validate $(SECRETS) -var-file debian-11/config-900.pkrvars.hcl $(DEB11) \
		&& $(PACKER) build $(SECRETS) -var-file debian-11/config-900.pkrvars.hcl $(DEB11)
