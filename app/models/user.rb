class User < ActiveRecord::Base
  attr_accessible :name, :email, :picture_url

  validates :name, presence: true

  has_many :authorizations, dependent: :destroy

  has_many :hosted_events, :class_name => "Event", :foreign_key => "host_id"

  def self.create_from_auth!(auth_hash)
    auth_hash = auth_hash.fetch("user_info")

    create!(
      name:        auth_hash.fetch("name"),
      email:       auth_hash.fetch("email", ""),
      picture_url: auth_hash.fetch("image", "")
    )
  end

  def linked_to?(service)
    authorizations.where(provider: service).any?
  end
end
