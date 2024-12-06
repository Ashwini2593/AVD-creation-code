# Copy this to a file named terraform.tfvars and fill in your specific values
resource_group_name = "rg-aztraining-cat-uk"
location            = "UK South"
vm_name             = "mynewvmmay"
vm_size             = "Standard_B1s"
vnet_name           = "vnet-aztraining-cat-uk-shared"
subnet_name         = "default"
admin_username      = "itcadmin"
admin_password      = "Welcomeitc@2024"
os_disk_type        = "Standard_LRS"
subscription_id     = "3a72be92-287b-4f1e-840a-5e3e71100139"
# virtual_network     = "vnet-aztraining-cat-uk-shared