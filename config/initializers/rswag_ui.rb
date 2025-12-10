Rswag::Ui.configure do |c|
  # List the OpenAPI endpoints that you want to be documented through the
  # swagger-ui. The first parameter is the path (absolute or relative to the UI
  # host) to the corresponding endpoint and the second is a title that will be
  # displayed in the document selector.

  c.openapi_endpoint "/api-docs/v1/swagger.yaml", "F1 Laps API V1 Docs"

  # Add Basic Auth in case your API is private
  # c.basic_auth_enabled = true
  # c.basic_auth_credentials 'username', 'password'

  # CRITICAL: Override Rswag's restrictive CSP to allow localhost API calls
  c.config_object["cspDisabled"] = true  # Disable Rswag's built-in CSP
  
  # UI configuration options
  c.config_object["defaultModelsExpandDepth"] = 2
  c.config_object["defaultModelExpandDepth"] = 2
  c.config_object["defaultModelRendering"] = "model"
  c.config_object["displayRequestDuration"] = true
  c.config_object["docExpansion"] = "list"
  c.config_object["filter"] = false  # Disable "Filter by tag" feature
  c.config_object["showExtensions"] = true
  c.config_object["showCommonExtensions"] = true
  c.config_object["tryItOutEnabled"] = true
  # Don't sort tags - use the order defined in swagger_helper.rb
end
