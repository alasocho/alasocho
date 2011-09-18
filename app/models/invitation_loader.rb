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
    scope = [:active_models, :errors, :invitations]

    errors[:leftovers] << I18n.t(:leftovers, scope: scope) if @leftovers.present?
    valid, invalid = @invitations.partition(&:valid?)

    invalid.each do |invitation|
      errors[:leftovers] << I18n.t(:invalid, email: invitation.email, scope: scope)
    end

    if @leftovers.blank? && @invitations.empty? && @event.published?
      errors[:leftovers] << I18n.t(:empty, scope: scope)
    end
  end

  def save_and_sanitize(invitations)
    @leftovers = invitations.delete("leftovers")
    @invitations = invitations.map do |_, invitation|
      @event.attendances.new(email: invitation.fetch("email"))
    end
  end
end
