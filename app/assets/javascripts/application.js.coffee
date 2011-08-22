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

  $("#notifications_link").click (event) ->
    $("#notifications").toggle()
    $(this).blur()
    false
