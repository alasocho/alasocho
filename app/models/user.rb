class User < ActiveRecord::Base
  attr_accessible :name, :email, :picture_url

  validates :name, presence: true

  has_many :authorizations, dependent: :destroy

  has_many :hosted_events, :class_name => "Event", :foreign_key => "host_id"
  has_many :attendances
  has_many :comments

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

  def can_be_linked_further?
    Authorization::PROVIDERS.any? { |provider| !linked_providers.include?(provider) }
  end

  def linked_providers
    authorizations.map(&:provider)
  end
end
