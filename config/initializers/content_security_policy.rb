# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

# DISABLED IN DEVELOPMENT
# Rswag has its own CSP that conflicts with Rails CSP
# Our custom middleware in rswag_csp.rb handles CSP for Swagger UI

if Rails.env.production?
  Rails.application.configure do
    config.content_security_policy do |policy|
      policy.default_src :self, :https
      policy.font_src    :self, :https, :data
      policy.img_src     :self, :https, :data, :blob
      policy.object_src  :none
      policy.script_src  :self, :https
      policy.style_src   :self, :https
      policy.connect_src :self, :https
    end
  end
end
