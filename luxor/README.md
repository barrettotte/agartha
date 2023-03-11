# Luxor

Packer, Ansible, Terraform

## Commands

- Initialize terraform, packer, misc - `make init`
- Provision all resources - `make`
  - Provision VM templates with Packer - `make vm_templates`
  - Provision resources with Terraform - `make provision` or just `make`

## Provisioning Problem

Randomly can't provision 1-2 VMs...no idea why

```txt
  device-mapper: resume ioctl on  (253:10) failed: Invalid argument
  Unable to resume ssd0-vm--900--disk--0 (253:10).
TASK ERROR: clone failed: can't refresh LV '/dev/ssd0/vm-900-disk-0' for activation:   Failed to reactivate ssd0/vm-900-disk-0.
```

Weirdly, running `terraform apply -auto-approve` again fixes the issue?

- https://support.hpe.com/hpesc/public/docDisplay?docId=c03744232&docLocale=en_US
- https://www.thegeekdiary.com/device-mapper-resume-ioctl-failed-invalid-argument-error-on-running-lvcreate-lvresize-lvextend/
