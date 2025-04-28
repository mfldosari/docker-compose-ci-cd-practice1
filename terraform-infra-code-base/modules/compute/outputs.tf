
output "fastapi_container_id" {
  value = azurerm_container_app.fastapi_app.identity[0].principal_id
}

output "streamlit_container_id" {
  value = azurerm_container_app.streamlit_app.identity[0].principal_id
}

output "url_fastapi_https" {
  value = azurerm_container_app.fastapi_app.latest_revision_fqdn
}

output "url_streamlit_https" {
  value = azurerm_container_app.streamlit_app.latest_revision_fqdn
}