A8.Views.Guests ?= {}

class A8.Views.Guests.Manageable extends Backbone.View
  events:
    "ajax:complete a": "update"

  render: ->
    this

  update: (event, xhr) ->
    li = $(xhr.responseText)
    $(@el).html(li.html())
