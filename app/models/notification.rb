module Notification
  def self.all(user, finder=user.attendances.need_attention.includes(:event))
    finder.map { |notification| new(notification) }
  end

  def self.new(attendance)
    if attendance.need_action?
      Invitation.new(attendance)
    else
      Comment.new(attendance)
    end
  end

  class Base
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr :attendance

    def initialize(attendance)
      @attendance = attendance
    end

    def object
      attendance.event
    end

    def persisted?
      false
    end

    delegate :name, to: :object
  end

  class Invitation < Base
    delegate :location, :available_slots, :limited?, to: :object

    def quota
      object.attendee_quota
    end

    def time
      object.start_at
    end
  end

  class Comment < Base
  end
end
