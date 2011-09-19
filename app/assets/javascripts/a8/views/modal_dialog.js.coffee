class A8.Views.ModalDialog extends Backbone.View
  events:
    "click": "open"

  initialize: ->
    _.bindAll this, "_show_modal", "_show_from_xhr", "close"

    @el = $(@el)
    @url = @el.attr("href")
    @mode = @options.mode

    $(document).keyup (event) =>
      if event.keyCode is 27
        this.close()
      true

    $(document).bind("close.modal", @close)

  open: ->
    @overlay?.remove()
    @overlay = $(document.body).append("<div class='modal-overlay'/>").children().last()

    $.ajax(
      url: @url
      type: "get"
      dataType: "script html"
      complete: @_show_from_xhr
    )

    return false

  close: ->
    return unless @visible
    @visible = false
    @overlay.animate(opacity: 0, "fast", -> $(this).remove())

  _show_modal: (data) ->
    @visible = true
    @overlay.html(data)
    @overlay.show().animate(opacity: 1)
    this._bind_events()
    $("body > .modal-overlay > .modal .close").click(@close)

  _show_from_xhr: (xhr) ->
    @_show_modal(xhr.responseText)

  _bind_events: ->
    return if @events_bound
    @events_bound = true

    replace_contents = (event, xhr, status) =>
      @_show_from_xhr(xhr)

    success = if @mode is "autoclose" then @close else replace_contents

    @overlay.delegate("form", "ajax:success", success)
    @overlay.delegate("form", "ajax:error", replace_contents)
