module "rg_project102_prod_eastus_001" {
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/resource_group"

  name     = var.rg_project102_prod_eastus_001.name
  location = var.rg_project102_prod_eastus_001.location
}