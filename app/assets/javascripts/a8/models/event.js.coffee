A8.Models ||= {}

class A8.Models.Event extends Backbone.Model
  end_at: ->
    end_at = this.get("end_at")
    new Date(end_at) if end_at
