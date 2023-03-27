# android-x86

My phone was too old for Philips Hue app...so made a VM for it

Downloaded iso from - https://www.android-x86.org/download

Current VM is Android 9

Setup VM with 2 cores, 4096 RAM, 16GB disk, vmbr0 (management)

https://hackmd.io/@StanS/Android-x86

need to edit grub boot option, replace `quiet` with `nomodeset xforcevesa`

```sh
# had to do this on local VMware, but not on proxmox ?
mkdir /mnt/sda
mount /dev/block/sda1 /mnt/sda
vi /mnt/sda/grub/menu.lst # replace quiet with nomodeset xforcevesa
```

skipped account setup, no google account

## Philips Hue

The whole reason I needed this VM...Philips Hue official app needs Android 10.0

https://philips-hue.en.uptodown.com/android/versions (4.30.0 -> Android+8.0)

installed Philips hue and setup bridge + lights
