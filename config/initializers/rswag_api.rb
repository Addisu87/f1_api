Rswag::Api.configure do |c|
  # Specify a root folder where Swagger JSON files are located
  # This is used by the Swagger middleware to serve requests for API descriptions
  # NOTE: If you're using rswag-specs to generate Swagger, you'll need to ensure
  # that it's configured to generate files in the same folder
  c.openapi_root = Rails.root.to_s + "/swagger"

  # Filter to sanitize any real JWT tokens that might have been captured
  # Remove actual Bearer tokens so users must enter their own
  c.swagger_filter = lambda do |swagger, env|
    # Recursively sanitize any JWT tokens in the swagger document
    def sanitize_swagger(obj)
      case obj
      when Hash
        obj.transform_values { |v| sanitize_swagger(v) }
      when Array
        obj.map { |v| sanitize_swagger(v) }
      when String
        # Remove any JWT tokens (Bearer followed by long base64 string)
        if obj.match?(/Bearer\s+eyJ[A-Za-z0-9_-]{20,}/)
          ""  # Empty value - user must enter their own token
        else
          obj
        end
      else
        obj
      end
    end

    sanitize_swagger(swagger)
  end
end
