class User::Anonymous
  attr_accessor :attendance

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
end
