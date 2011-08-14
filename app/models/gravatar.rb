class Gravatar
  def initialize(email)
    @email = email || ""
  end

  def path(options = {})
    options[:size] ||= 96
    "http://www.gravatar.com/avatar/#{Digest::MD5::hexdigest(@email.downcase)}?s=#{options[:size]}&d=monsterid"
  end
end
