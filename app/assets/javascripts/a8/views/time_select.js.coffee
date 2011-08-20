class A8.Views.TimeSelect extends Backbone.View
  template: $("[data-template-for='TimeSelect']").html()

  events:
    "change .date, .time": "update_time"

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
      beforeShow: _.bind(this._before_datepicker_show, this)
    )

    if this.time.getFullYear() # NaN if an invalid date
      this.dateField.val(this.to_date_string())
      this.timeField.val(this.to_time_string())

    this

  update_time: (event) ->
    date = $.datepicker.formatDate(
      "yy-mm-dd",
      $.datepicker.parseDate(
        this.dateFormat,
        this.dateField.val()
      )
    )
    time = this.timeField.val()
    tz_offset = tz_offset_string(this.options.tz_offset)

    this.datetimeField.val("#{date}T#{time}:00#{tz_offset}")
    this.time = new Date(this.datetimeField.val())

  to_date_string: ->
    $.datepicker.formatDate(this.dateFormat, this.time)

  to_time_string: ->
    "#{zero_pad(this.time.getHours(), 2)}:#{zero_pad(this.time.getMinutes(), 2)}"

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
