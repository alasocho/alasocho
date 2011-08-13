class User < ActiveRecord::Base
  attr_accessible :name, :email, :picture_url

  validates :name, presence: true

  has_many :authorizations, dependent: :destroy
  has_many :attendances

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

  def interested_to_attend
    attendances.need_attention
  end

  def linked_to?(service)
    authorizations.where(provider: service).any?
  end

  def can_be_linked_further?
    (Authorization::PROVIDERS & linked_providers).any?
  end

  def linked_providers
    authorizations.map(&:provider)
  end

  def merge_with(another_user)
    transaction do
      another_user.hosted_events.update_all(host_id: id)
      another_user.attendances.update_all(user_id: id)
      another_user.comments.update_all(user_id: id)
      another_user.authorizations.update_all(user_id: id)
      another_user.destroy
    end
  end
end
