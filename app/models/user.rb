class User < ActiveRecord::Base
  has_many :authorizations, dependent: :destroy
  has_many :attendances

  has_many :hosted_events, :class_name => "Event", :foreign_key => "host_id"
  has_many :attendances
  has_many :comments

  validates :name, presence: true

  attr_accessible :name, :email, :picture_url, :wants_comment_notifications

  scope :want_comment_notifications, where(:wants_comment_notifications => true)

  has_many :interesting_invitations, :class_name => "Attendance", :conditions => { :state => Attendance::STATES_INTERESTED }
  has_many :interests, :through => :interesting_invitations, :source => :event

  has_many :invitations_timeline, :class_name => "Attendance", :conditions => { :state => Attendance::STATES_RELEVANT }
  has_many :events_timeline, :through => :invitations_timeline, :source => :event

  has_many :pending_attendances, :class_name => "Attendance", :conditions => { :state => "invited" }
  has_many :pending_events, :through => :pending_attendances, :source => :event



  def self.create_from_auth!(auth_hash)
    auth_hash = auth_hash.fetch("user_info")

    create!(
      name:        auth_hash.fetch("name"),
      email:       auth_hash.fetch("email", ""),
      picture_url: auth_hash.fetch("image", "")
    )
  end

  def picture_url
    super.presence || Gravatar.new(email).path
  end

  def linked_to?(service)
    authorizations.where(provider: service).any?
  end

  def can_be_linked_further?
    (Authorization::PROVIDERS - linked_providers).any?
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
