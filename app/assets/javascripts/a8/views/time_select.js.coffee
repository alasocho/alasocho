class A8.Views.TimeSelect extends Backbone.View
  template: $("[data-template-for='TimeSelect']").html()

  events:
    "change .date": "update_time"
    "change .time": "update_time"

  render: ->
    this.datetime_field = this.$("input[type^=datetime]").hide()
    this.time = new Date(this.datetime_field.val())

    _template = _.template(this.template, prefix: this.options.field)
    $(this.el).append(_template)

    this.date_field  = this.$("input[id$=date]").addClass("date")
    this.time_field  = this.$("select[id$=time]").addClass("time")
    this.date_format = this.date_field.data("format")

    $(this.datetime_field[0].labels).attr("for", this.date_field.attr("id"))

    this.date_field.datepicker(
      beforeShow: _.bind(this._before_datepicker_show, this)
    )

    if this.time.getFullYear() # NaN if an invalid date
      this.date_field.val(this.to_date_string())
      this.time_field.val(this.to_time_string())

    this

  update_time: (event) ->
    date = $.datepicker.formatDate(
      "yy-mm-dd",
      $.datepicker.parseDate(
        this.date_format,
        this.date_field.val()
      )
    )
    time = this.time_field.val()
    tz_offset = tz_offset_string(this.options.tz_offset)

    this.datetime_field.val("#{date}T#{time}:00#{tz_offset}")
    this.time = new Date(this.datetime_field.val())

  to_date_string: ->
    $.datepicker.formatDate(this.date_format, this.time)

  to_time_string: ->
    hours = zero_pad(this.time.getHours(), 2)
    minutes = zero_pad(this.time.getMinutes(), 2)
    "#{hours}:#{minutes}"

  _before_datepicker_show: ->
    options = minDate: new Date

    if this.options.min?
      options.minDate = this.options.min.time

    if this.options.max?
      options.maxDate = this.options.max.time

    options

tz_offset_string = (offset) ->
  negative = if offset < 0 then "-" else ""
  "#{negative}#{zero_pad(Math.abs(offset), 2)}00"

zero_pad = (number, length) ->
  number = number.toString()
  while number.length < length
    number = "0" + number
  number
