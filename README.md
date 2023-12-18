# Packer config

My packer configs for XCP-ng. I am using the [Xenserver plugin](github.com/ddelnano/xenserver) from ddlenano.

## Usage

Replace variables with yours and run:

```shell
packer init .
packer validate .
packer build rhel9.pkr.hcl
```
