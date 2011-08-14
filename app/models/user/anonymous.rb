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
  end
end
