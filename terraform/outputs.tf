output "jenkins_ip" { value = azurerm_public_ip.jenkins.ip_address }
output "acr_name" { value = azurerm_container_registry.acr.name }
output "sonar_ip" { value = azurerm_public_ip.sonar.ip_address }
output "sonar_private_ip" { value = azurerm_network_interface.sonar.private_ip_address }
