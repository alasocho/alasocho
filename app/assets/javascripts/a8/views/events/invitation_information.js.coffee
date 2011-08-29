class A8.Views.Events.InvitationInformation extends Backbone.View
  initialize: ->
    @model.bind("change:attendee_quota", _.bind(@update, this))

  update: ->
    count = @model.get("attendee_quota")

    return @el.hide() unless count

    if count == 1
      @el.show().html(@options.one)
    else
      @el.show().html(@options.many.replace(/%many%/, count))
