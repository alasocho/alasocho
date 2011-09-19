A8.Views.Events ||= {}

class A8.Views.Events.TimezoneSelector extends Backbone.View
  tagName: "span"
  className: "help-block timezone"

  template: $("[data-template-for='TimezoneSelector']").html()

  render: ->
    $(@el).html(_.template(@template, {}))
    $(@options.container).append(@el)
