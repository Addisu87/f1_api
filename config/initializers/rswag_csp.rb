# MONKEY PATCH Rswag to disable its restrictive CSP
# Rswag's built-in CSP blocks localhost API calls and can't be easily overridden

if defined?(Rswag::Ui)
  module Rswag
    module Ui
      class Middleware
        # Override the call method to remove CSP header after Rswag sets it
        alias_method :original_call, :call

        def call(env)
          status, headers, body = original_call(env)

          # Remove Rswag's restrictive CSP for all /api-docs routes
          if env["PATH_INFO"].to_s.start_with?("/api-docs")
            # Remove the Content-Security-Policy header entirely
            headers.delete("Content-Security-Policy")
            headers.delete("content-security-policy")
          end

          [ status, headers, body ]
        end
      end
    end
  end
end
