variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
 // default     = "my-existing-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "UK South"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "my-vnet-may"
}

variable "subnet_name" {
  description = "Name of the Subnet"
  type        = string
  default     = "my-subnet-may"
}

variable "vm_name" {
  description = "Name of the Virtual Machine"
  type        = string
 // default     = "my-vm-may"
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  //default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

variable "os_disk_type" {
  description = "Type of OS disk"
  type        = string
  // default     = "Standard_LRS"
}