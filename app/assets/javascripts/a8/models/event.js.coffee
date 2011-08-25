A8.Models ||= {}

class A8.Models.Event extends Backbone.Model
  initialize: ->
    @invitations = new A8.Collections.Invitations(model: this)

  start_at: ->
    new Date(this.get("start_at"))

  end_at: ->
    end_at = this.get("end_at")
    new Date(end_at) if end_at
