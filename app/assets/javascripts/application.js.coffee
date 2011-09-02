#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require backbone-rails
#= require_self
#= require_tree ./a8

@A8 = {
  Models:      {}
  Collections: {}
  Routers:     {}
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
      $("#notifications").hide()
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
