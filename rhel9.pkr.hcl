packer {
  required_plugins {
   xenserver= {
      version = ">= v0.5.3"
      source = "github.com/ddelnano/xenserver"
    }
  }
}

variable "remote_host" {
  type        = string
  description = "The ip or fqdn of your XenServer. This will be pulled from the env var 'PKR_VAR_remote_host'"
  sensitive   = true
  default     = "10.0.0.1"
}

variable "remote_password" {
  type        = string
  description = "The password used to interact with your XenServer. This will be pulled from the env var 'PKR_VAR_remote_password'"
  sensitive   = true
  default     = "password"
}

variable "remote_username" {
  type        = string
  description = "The username used to interact with your XenServer. This will be pulled from the env var 'PKR_VAR_remote_username'"
  sensitive   = true
  default     = "root"

}

variable "sr_iso_name" {
  type        = string
  default     = "Local ISOs"
  description = "The ISO-SR to packer will use"

}

variable "sr_name" {
  type        = string
  default     = "Local storage"
  description = "The name of the SR to packer will use"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "") 
}

source "xenserver-iso" "rhel9-netinstall" {
  iso_name       = "rhel-9.2-x86_64-boot.iso"

  sr_iso_name    = var.sr_iso_name
  sr_name        = var.sr_name
  tools_iso_name = "guest-tools.iso"

  remote_host     = var.remote_host
  remote_password = var.remote_password
  remote_username = var.remote_username

  vm_name         = "packer-rhel9-netinstall-${local.timestamp}"
  vm_description  = "Build started: ${local.timestamp}\n This was installed with an external repository"
  vm_memory       = 4096
  vcpus_atstartup = 2
  vcpus_max       = 2
  disk_size       = 102400
  network_names   = ["SOMENET1"]

  http_directory = "http"
  boot_command   = ["<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks-rhel9-netinstall.cfg<enter><wait>"]
  boot_wait      = "10s"

  ssh_username     = "user"
  ssh_password     = "password"
  ssh_wait_timeout = "10000s"

  output_directory = "packer-rhel9-netinstall"
  keep_vm          = "on_success"
  format           = "none"
}

build {
  sources = ["xenserver-iso.rhel9-netinstall"]
}
