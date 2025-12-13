# Remove CSP headers in development to allow Swagger UI to work
# Swagger UI needs to make API calls to the same server
if Rails.env.development?
  # Custom middleware to remove CSP headers
  class RemoveCspHeaders
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      # Remove CSP-related headers
      headers.delete("Content-Security-Policy")
      headers.delete("Content-Security-Policy-Report-Only")

      [ status, headers, response ]
    end
  end

  # Insert middleware after CSP middleware runs to remove the headers
  Rails.application.config.middleware.use RemoveCspHeaders
end
