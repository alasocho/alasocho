class InvitationLoader
  def self.model_name
    ActiveModel::Name.new(self, nil, "Invitations")
  end

  attr :event
  attr :invitations

  def initialize(event, params, invitation_factory=Invitation)
    params = params.dup

    @event = event
    @leftovers = params.delete("leftovers")
    @invitations = params.map do |_, invitation|
      invitation_factory.new(event.attendances, invitation.fetch("email"))
    end
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
    invitations.map(&:email).concat([@leftovers]).join(", ")
  end

  private

  def validate
    scope = [:active_models, :errors, :invitations]

    errors[:leftovers] << I18n.t(:leftovers, scope: scope) if @leftovers.present?
    valid, invalid = invitations.partition(&:valid?)

    invalid.each do |invitation|
      errors[:leftovers] << I18n.t(:invalid, email: invitation.email, scope: scope)
    end

    if @leftovers.blank? && invitations.empty? && event.published?
      errors[:leftovers] << I18n.t(:empty, scope: scope)
    end
  end
end
