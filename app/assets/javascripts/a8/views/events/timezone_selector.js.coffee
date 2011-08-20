A8.Views.Events ||= {}

class A8.Views.Events.TimezoneSelector extends Backbone.View
  tagName: "p"
  className: "timezone"

  template: $("[data-template-for='TimezoneSelector']").html()

  render: ->
    $(this.el).html(_.template(this.template, {}))
    $(this.options.container).append(this.el)
