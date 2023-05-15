# giza

Debian VM with Docker containers for general services.

## GPU Passthrough For Jellyfin

iommu enabled

```sh
# blacklist drivers on proxmox node
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
echo "blacklist nvidia" >> /etc/modprobe.d/blacklist.conf
update-initramfs -u
# reboot
```

`lspci -k | grep -A 2 -i "VGA"`

GPU passthrough: all functions, ROM-bar, PCI-Express

- https://docs.linuxserver.io/images/docker-jellyfin
- https://github.com/NVIDIA/nvidia-docker

```sh
# https://www.reddit.com/r/debian/comments/11ixewp/cant_install_the_nvidia_driver_on_debian_11/
# https://jellyfin.org/docs/general/administration/hardware-acceleration/nvidia
# https://wiki.debian.org/NvidiaGraphicsDrivers

sudo apt install linux-headers-amd64

echo "blacklist nouveau" | sudo tee -a /etc/modprobe.d/blacklist.conf
sudo update-initramfs -u
sudo reboot now

sudo apt-get install -y software-properties-common
sudo apt-add-repository non-free
sudo apt-add-repository contrib

sudo apt update
sudo apt-get install -y dkms nvidia-detect
sudo apt-get install -y nvidia-driver firmware-misc-nonfree
sudo reboot now

sudo apt update
sudo apt install -y libnvcuvid1 libnvidia-encode1
sudo apt-get install -y nvidia-cuda-dev nvidia-cuda-toolkit
sudo reboot now

sudo apt-get install -y nvidia-smi nvtop
sudo reboot now

# worked!
```

```sh
# nvidia container runtime
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
```

```jsonc
// /etc/docker/daemon.json
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
```

```sh
sudo systemctl restart docker

# verify GPU is still there
nvidia-smi -L
nvidia-smi --loop=1

# verify GPU passed to container
docker run --rm --gpus all nvidia/cuda:12.1.0-base-ubuntu18.04 nvidia-smi
```

TODO: convert to ansible playbook

## Jellyfin Config

- Playback - Hardware acceleration
  - NVIDIA NVENC
  - Enabled hardware decoding for all formats
  - Enabled enhanced NVDEC decoder
  - Enabled hardware encoding
  - Enabled allow encoding in HEVC format
- Networking
  - Known Proxies: jericho.agartha

Reminder: allow both http/https to jericho for Roku

TODO: convert to ansible playbook
