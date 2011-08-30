class A8.Views.Events.HourSelector extends Backbone.View
  initialize: ->
    this.set_min_time(@options.min_time) if @options.min_time?
    this.set_max_time(@options.max_time) if @options.max_time?
    this.set_current_time(@options.time) if @options.time?

  render: ->
    @children = this.$("option")
    _.each @children, _.bind(this._set_option_time, this)
    this

  set_current_time: (@time) ->

  set_min_time: (@min_time) ->
    this._update_options()

  set_max_time: (@max_time) ->
    this._update_options()

  _update_options: ->
    _.each @children, (option) =>
      option = this._set_option_time(option)

      if this._is_valid(option)
        option.removeAttr("disabled")
      else
        option.attr("disabled", "disabled")

  _set_option_time: (option) ->
    option = $(option)
    [hours, minutes] = option.val().split(":")
    time = new Date(@time)
    time.setHours(hours)
    time.setMinutes(minutes)
    option.data("time", time)

  _is_valid: (option) ->
    time = option.data("time")
    if time?.isValid()
      @min_time < time < @max_time
    else
      true # ignore options when the date hasn't been set
