require 'bcrypt'

class TokenMaker
  LENGTH = 10

  def initialize(object)
    @object = object
  end

  def make
    BCrypt::Password.create(element_identifier + ALasOcho.config[:token_secret]).gsub(/[^A-Za-z0-9]/, '')[-LENGTH,LENGTH]
  end

  def element_identifier
    "#{@object.class.name}-#{@object.id}"
  end
end
