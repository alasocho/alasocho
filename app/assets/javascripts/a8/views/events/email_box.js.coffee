A8.Views.Events ?= {}

class A8.Views.Events.EmailBox extends Backbone.View
  events:
    "keyup textarea": "_keyup"

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
    @prev_val = @textarea.val()

    tokenizer = new EmailTokenizer @prev_val, (email) =>
      @collection.add(new A8.Models.Invitation(email: email))
    tokenizer.tokenize()

    @textarea.val(tokenizer.leftovers())

  _keyup: (event) ->
    return if @textarea.val() is @prev_val
    clearTimeout(@timeout)
    @timeout = setTimeout (=> this.tokenize()), 200

  _add_invite: (invitation) ->
    invite_view = new A8.Views.Events.BoxInvitation(model: invitation)
    @invites.append(invite_view.render())
    this._adjust_padding(false)

  _remove_invite: (invitation) ->
    this._adjust_padding(true)

  _adjust_padding: (removing) ->
    list_padding = parseInt(@invites.css("padding-top"))
    item_height = if removing then @invites.height() / $("li", @invites).length else 0
    @textarea.css(paddingTop: list_padding + @invites.height() - item_height + "px")

class EmailTokenizer
  regexp: /\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i
  tokens: [",", ";", "\n"]

  constructor: (@string, @callback) ->
    @valid_indices = []

  tokenize: (callback) ->
    this._rewind()

    while @pos < @string.length
      @char = @string[@pos]

      if @char in @tokens
        this._flush_buffer(callback)
        @last_pos = @pos
      else
        @buffer += @char

      @pos++

  leftovers: ->
    chars = String(@string).split("")

    _.each @valid_indices.reverse(), (pair) ->
      chars.splice(pair[0], pair[1] - pair[0], [])

    tokens = @tokens.join("")

    clean_leftover_tokens = ///
      ^[#{tokens}]|([^#{tokens}][#{tokens}])[#{tokens}]*
    ///ig

    lack_of_whitespace = ///
      ([^#{tokens}][#{tokens}])\s*([^#{tokens}])
    ///ig

    chars.join("").
      replace(clean_leftover_tokens, '$1').
      replace(lack_of_whitespace, '$1 $2').
      replace(/^\s+/, '').
      replace(/\s+$/, ' ')

  _rewind: ->
    @pos = 0
    @last_pos = 0
    @buffer = ""

  _flush_buffer: ->
    if this._valid_buffer()
      @valid_indices.push [@last_pos, @pos]
      @callback?(@buffer)
    @buffer = ""

  _valid_buffer: ->
    @buffer.trim().length isnt 0 and @buffer.match(@regexp)
