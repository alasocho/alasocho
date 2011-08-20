class A8.Views.TimeSelect extends Backbone.View
  template: $("[data-template-for='TimeSelect']").html()

  events:
    "change .date": "update_time"
    "change .time": "update_time"

  before_datepicker_show: ->
    options = minDate: new Date

    if this.options.limit_min?
      options.minDate = this.options.limit_min.time

    if this.options.limit_max?
      options.maxDate = this.options.limit_max.time

    options

  update_time: (event) ->
    date = $.datepicker.formatDate(
      "yy-mm-dd",
      $.datepicker.parseDate(
        this.dateFormat,
        this.dateField.val()
      )
    )
    time = this.timeField.val()

    this.datetimeField.val("#{date}T#{time}:00#{this._time_zone_offset()}")
    this.time = new Date(this.datetimeField.val())

  render: ->
    this.datetimeField = this.$("input[type^=datetime]").hide()
    this.time = new Date(this.datetimeField.val())

    _template = _.template(this.template, prefix: this.options.field)
    $(this.el).append(_template)

    this.dateField  = this.$("input[id$=date]").addClass("date")
    this.timeField  = this.$("select[id$=time]").addClass("time")
    this.dateFormat = this.dateField.data("format")

    $(this.datetimeField[0].labels).attr("for", this.dateField.attr("id"))

    this.dateField.datepicker(
      beforeShow: _.bind(this.before_datepicker_show, this)
    )

    if this.time.getFullYear() # NaN if an invalid date
      this.dateField.val(this.to_date_string())
      this.timeField.val(this.to_time_string())

    this

  to_date_string: ->
    $.datepicker.formatDate(this.dateFormat, this.time)

  to_time_string: ->
    "#{zero_pad(this.time.getHours(), 2)}:#{zero_pad(this.time.getMinutes(), 2)}"

  _time_zone_offset: ->
    negative = if this.options.tz_offset < 0 then "-" else ""
    "#{negative}#{zero_pad(Math.abs(this.options.tz_offset), 2)}00"

zero_pad = (number, length) ->
  number = number.toString()
  while number.length < length
    number = "0" + number
  number
