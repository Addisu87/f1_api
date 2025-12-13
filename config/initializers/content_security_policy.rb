# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

# In development, completely disable CSP to allow Swagger UI to work properly
# Swagger UI needs to make API calls to the same server, and CSP interferes
# We skip defining the CSP policy entirely in development
if Rails.env.production?
  # In production, enforce CSP properly
  Rails.application.config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none
    policy.script_src  :self, :https
    policy.style_src   :self, :https
  end

  Rails.application.config.content_security_policy_report_only = false
end
