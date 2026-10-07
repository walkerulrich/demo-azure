variable "subscription_id" { type = string }
variable "my_ip" { type = string } # ex : 82.12.34.56/32

locals {
  location     = "swedencentral"
  jenkins_size = "Standard_D2s_v6"                                  # 2 vCPU
  aks_size     = "Standard_D2s_v6"                                  # 2 vCPU x 2 noeuds = 4 vCPU
  sonar_size   = "Standard_D2s_v6"                                  # 2 vCPU
  acr_name     = "acrdemo${substr(md5(var.subscription_id), 0, 8)}" # nom unique dans Azure
}
