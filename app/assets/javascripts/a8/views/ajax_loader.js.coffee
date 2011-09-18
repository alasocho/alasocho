class A8.Views.AjaxLoader extends Backbone.View
  tagName: "div"
  id: "ajax-loader"

  initialize: ->
    @body = $(document.body)
    @el = $(@el)

  render: ->
    @el.html(@options.label || "Loading...")
    @body.append(@el.hide())

    @body.ajaxStart =>
      @el.show()

    @body.ajaxStop =>
      @el.hide()
