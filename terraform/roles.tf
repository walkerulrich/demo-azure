resource "azurerm_role_assignment" "aks_pull" { # AKS lit les images
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "jenkins_push" { # Jenkins pousse les images
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPush"
  principal_id                     = azurerm_linux_virtual_machine.jenkins.identity[0].principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "jenkins_aks" { # Jenkins recupere le kubeconfig
  scope                            = azurerm_kubernetes_cluster.aks.id
  role_definition_name             = "Azure Kubernetes Service Cluster User Role"
  principal_id                     = azurerm_linux_virtual_machine.jenkins.identity[0].principal_id
  skip_service_principal_aad_check = true
}
