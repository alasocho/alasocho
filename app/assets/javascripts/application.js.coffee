#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require backbone-rails
#= require_self
#= require_tree ./a8

@A8 = {
  Models:      {}
  Collections: {}
  Views:       {}
}

_.templateSettings = {
  interpolate: /\%\{(.+?)\}/g
  evaluate:    /\[\[(.+?)\]\]/g
}

Date::isValid = ->
  this.getFullYear() or this.getFullYear() is 0

jQuery ($) ->
  $(document).keyup (event) ->
    if event.keyCode is 27
      $("#notifications").removeClass("open")
      $("li.menu.open").removeClass("open")

  $(document).click (event) ->
    _.each $("li.menu"), (menu) ->
      if $(menu).hasClass("open") and not $.contains(menu, event.target)
        $(menu).removeClass("open")

  $("li.menu a").click (event) ->
    $(this).parent().toggleClass("open")

  # should we care about the performance considerations of this?
  $("*").focus (event) ->
    $("li.menu").each ->
      menu = $(this)
      if menu.hasClass("open") and not $.contains(this, document.activeElement)
        menu.removeClass("open")

  $(".alert-message .close").click (event) ->
    el = $(this).parent()
    el.animate(
      marginTop: "-120px",
      "fast",
      _.bind(el.remove, el)
    )

  $("[data-modal]").each ->
    link = $(this)
    new A8.Views.ModalDialog(el: link, mode: link.data("modal"))

  $("#features aside").each (offset) ->
    el = $(this)
    rotation = $("#features aside").length

    setTimeout (->
      setInterval (->
        position = el.css("background-position")
        current  = parseInt(position.split(" ")[0])
        position = position.replace(/^\d+/, current + 460)
        el.css("background-position", position)
      ), rotation * 4000
    ), offset * 2000 + 100
