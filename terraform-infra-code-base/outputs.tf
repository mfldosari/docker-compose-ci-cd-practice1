output "url_fastapi_https" {
  value = "Fastapi is running on: https://${module.compute.url_fastapi_https}"
}

output "url_streamlit_https" {
  value = "Streamlit is running on: https://${module.compute.url_streamlit_https}"
}