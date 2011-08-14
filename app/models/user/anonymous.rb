class User::Anonymous
  attr_accessor :attendance

  extend ActiveModel::Naming
  include ActiveModel::Conversion

  def initialize(attendance)
    self.attendance = attendance
  end

  delegate :email, :to => :attendance

  def name
    email.try(:gsub, /@(.).*$/, '@\1...') || ""
  end

  def picture_url
    Gravatar.new(email).path
  end

  def self.model_name
    User.model_name
  end

  # ActiveModel::Conversion seems to rely on that
  def persisted?
    false
  end


end
