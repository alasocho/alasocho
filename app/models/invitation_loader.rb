class InvitationLoader
  extend ActiveModel::Naming

  def self.model_name
    ActiveModel::Name.new(self, nil, "Invitations")
  end

  def initialize(event, invitations)
    @event = event
    save_and_sanitize(invitations)
  end

  def valid?
    errors.clear
    validate
    errors.empty?
  end

  def errors
    @errors ||= ActiveModel::Errors.new(self)
  end

  def leftovers
    @invitations.map(&:email).concat([@leftovers]).join(", ")
  end

  private

  def validate
    errors[:leftovers] << "No todas las direcciones son validas." if @leftovers.present?
    valid, invalid = @invitations.partition(&:valid?)
    invalid.each do |invitation|
      errors[:leftovers] << "#{invitation.email} no es valida"
    end
  end

  def save_and_sanitize(invitations)
    @leftovers = invitations.delete("leftovers")
    @invitations = invitations.map do |_, invitation|
      @event.attendances.new(email: invitation.fetch("email"))
    end
  end
end
