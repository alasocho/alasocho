A8.Views.Events ||= {}

class A8.Views.Events.Scheduler extends Backbone.View
  render: ->
    el = $(@el)

    @start = new A8.Views.Events.TimeSelector(
      el:    el[0]
      model: @model
      field: "start_at"
    ).render()

    @end = new A8.Views.Events.TimeSelector(
      el:    el[1]
      model: @model
      field: "end_at"
    ).render()

    @end_toggle = new A8.Views.Events.EndDateToggle(
      $.extend(
        @options.toggle,
        el: el[1]
        model: @model
        always_hide: @end.$("[type^=datetime]")
      )
    ).render()

    @tz_selector = new A8.Views.Events.TimezoneSelector(
      container: @el.parent()
    ).render()

    @start.bind("timechange", _.bind(@_start_changed, this))
    @end.bind("timechange", _.bind(@_end_changed, this))

    this

  _start_changed: (time) ->
    @start.set_max_time(@end.time) if @end.time.isValid()
    @end.set_min_time(time)

  _end_changed: (time) ->
    @start.set_max_time(time)
    @end.set_min_time(@start.time) if @start.time.isValid()
