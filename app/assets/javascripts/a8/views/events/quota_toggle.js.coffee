class A8.Views.Events.QuotaToggle extends Backbone.View
  events:
    "change :input": "dom_updated"
    "keyup :input": "dom_updated"

  initialize: ->
    _.bindAll this, "model_updated"
    @model.bind("change:attendee_quota", @model_updated)

  render: ->
    @input = this.$(":input")
    this.model_updated()

  model_updated: ->
    return if @_ignore_model_events

    try
      @_ignore_dom_events = true
      @input.val(@model.get("attendee_quota"))
    finally
      @_ignore_dom_events = false

    true

  dom_updated: ->
    return if @_ignore_dom_events

    try
      @_ignore_model_events = true
      @model.set(attendee_quota: parseInt(@input.val()))
    finally
      @_ignore_model_events = false

    true
