A8.Views.Events ?= {}

class A8.Views.Events.EmailBox extends Backbone.View
  tokenizer: /[,;\n]/g

  events:
    "keyup textarea": "tokenize"

  initialize: ->
    @collection.bind("add", _.bind(@_add_invite, this))
    @collection.bind("remove", _.bind(@_remove_invite, this))

  render: ->
    @textarea  = this.$("textarea").wrap("<div/>")
    @invites   = $("<ul/>")
    @prev_val  = @textarea.val()
    wrapper    = @textarea.parent()
    wrapper.prepend(@invites)

    this

  tokenize: ->
    return if @textarea.val() is @prev_val
    @prev_val = @textarea.val()

    emails = @prev_val.split(@tokenizer)
    @textarea.val(emails.pop())

    _.each _.select(emails, (e) -> e.trim().length), _.bind(@invite, this)

  invite: (email) ->
    @collection.add(email: email.trim())

  _add_invite: (invitation) ->
    invite_view = new A8.Views.Events.BoxInvitation (
      collection: @collection
      model:      invitation
    )
    @invites.append(invite_view.render())
    this._adjust_padding(false)

  _remove_invite: (invitation) ->
    this._adjust_padding(true)

  _adjust_padding: (removing) ->
    list_padding = parseInt(@invites.css("padding-top"))
    item_height = if removing then @invites.height() / $("li", @invites).length else 0
    @textarea.css(paddingTop: list_padding + @invites.height() - item_height + "px")
