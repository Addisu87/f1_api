class DriverSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :name,
             :code,
             :team,
             :country,
             :profile_picture_url,
             :created_at,
             :updated_at

  def profile_picture_url
    return unless object.profile_picture.attached?

    # Relative path to Active Storage blob; frontend can prepend host as needed
    rails_blob_path(object.profile_picture, only_path: true)
  end
end
