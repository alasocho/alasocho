class Event < ActiveRecord::Base
  has_many :attendances
  has_many :comments
end
