class A8.Views.Events.PrivateToggle extends Backbone.View
  events:
    "change #event_public":        "change_public"
    "change #event_allow_invites": "change_invites"

  initialize: ->
    _.bindAll this, "model_updated"

    @model.bind("change:public", @model_updated)
    @model.bind("change:allow_invites", @model_updated)

  render: ->
    @public_checkbox = this.$("#event_public")
    @invite_checkbox = this.$("#event_allow_invites")
    this.model_updated() # set the initial state

  model_updated: ->
    @_ignore_dom_events = true

    try
      if @model.get("public")
        @public_checkbox.attr("checked", "checked")
        @invite_checkbox.attr("checked", "checked")
        @invite_checkbox.attr("disabled", "disabled")
      else
        @public_checkbox.removeAttr("checked")
        @invite_checkbox.removeAttr("disabled")
        if @model.get("allow_invites")
          @invite_checkbox.attr("checked", "checked")
        else
          @invite_checkbox.removeAttr("checked")

    finally
      @_ignore_dom_events = false

  change_public: ->
    return if @_ignore_dom_events
    @model.set(public: @public_checkbox.attr("checked") is "checked")

  change_invites: ->
    return if @_ignore_dom_events
    @model.set(allow_invites: @invite_checkbox.attr("checked") is "checked")
