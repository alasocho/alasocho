class User::Anonymous
  attr_accessor :attendance

  def initialize(attendance)
    self.attendance = attendance
  end

  delegate :email, :to => :attendance

  def name
    email.gsub(/@(.).*$/, '@\1...')
  end

  def picture_url
  end
end
