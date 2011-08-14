class Gravatar
  def initialize(email)
    @email = email || ""
  end

  def path(options = {})
    options[:size] ||= 96
    "http://www.gravatar.com/avatar/#{Digest::MD5::hexdigest(@email.downcase)}?s=#{options[:size]}&d=#{ default_avatar }"
  end

  def default_avatar
    hash = @email.hash % 16
    "http://#{ ALasOcho.config[:canonical_host] }/assets/default_avatars/#{ hash }.jpg"
  end
end
