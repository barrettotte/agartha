#!/bin/bash

# sanity check for VLAN isolation

base_addr=10.42
declare -a subnets=(0 5 10 25 30 35 40 50)

for i in "${subnets[@]}"
do
  echo '*************************'
  echo "$base_addr.$i.0/24"
  nmap "$base_addr.$i.0/24" --open
done
