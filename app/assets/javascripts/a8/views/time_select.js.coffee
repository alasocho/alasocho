class A8.Views.TimeSelect extends Backbone.View
  template: $("[data-template-for='TimeSelect']").html()

  events:
    "change .date": "update_time"
    "change .time": "update_time"

  render: ->
    @datetime_field = this.$("input[type^=datetime]").hide()
    @time = new Date(@datetime_field.val())

    _template = _.template(@template, prefix: @options.field)
    $(@el).append(_template)

    @date_field  = this.$("input[id$=date]").addClass("date")
    @time_field  = this.$("select[id$=time]").addClass("time")
    @date_format = @date_field.data("format")

    $(@datetime_field[0].labels).attr("for", @date_field.attr("id"))

    @date_field.datepicker(
      beforeShow: _.bind(@_before_datepicker_show, this)
    )

    if @time.getFullYear() # NaN if an invalid date
      @date_field.val(this.to_date_string())
      @time_field.val(this.to_time_string())

    this

  update_time: (event) ->
    date = $.datepicker.formatDate(
      "yy-mm-dd",
      $.datepicker.parseDate(
        @date_format,
        @date_field.val()
      )
    )
    time = @time_field.val()
    tz_offset = tz_offset_string(@options.tz_offset)

    @datetime_field.val("#{date}T#{time}:00#{tz_offset}")
    @time = new Date(@datetime_field.val())

  to_date_string: ->
    $.datepicker.formatDate(@date_format, @time)

  to_time_string: ->
    hours = zero_pad(@time.getHours(), 2)
    minutes = zero_pad(@time.getMinutes(), 2)
    "#{hours}:#{minutes}"

  _before_datepicker_show: ->
    options = minDate: new Date

    if @options.min?
      options.minDate = @options.min.time

    if @options.max?
      options.maxDate = @options.max.time

    options

tz_offset_string = (offset) ->
  negative = if offset < 0 then "-" else ""
  "#{negative}#{zero_pad(Math.abs(offset), 2)}00"

zero_pad = (number, length) ->
  number = number.toString()
  while number.length < length
    number = "0" + number
  number
