output "jenkins_ip" { value = azurerm_public_ip.jenkins.ip_address }
output "acr_name" { value = azurerm_container_registry.acr.name }
