class A8.Views.Events.SettingsView extends Backbone.View
  attendee_quota: -> $(".attendee_quota")

  public_checkbox: -> $("#event_public")

  invitee_checkbox: -> $("#event_allow_invites")

  previous_attendee_quota: 0

  valid_numbers: =>
    current_value = this.attendee_quota().val()
    if current_value < 0
      this.attendee_quota().val(0)
      current_value = 0
    this.watcher?.counter_updated current_value

  initialize: (@el, @watcher) ->
    $(".unlimited_attendee_quota").hide()
    this.valid_numbers()
    this.attendee_quota().click this.valid_numbers
    this.public_checkbox().click =>
      if !this.public_checkbox().attr('checked')
        this.invitee_checkbox().attr('disabled', false)
      else
        this.invitee_checkbox().attr('checked', true)
        this.invitee_checkbox().attr('disabled', true)

    $(this.el).toggle(=>
          value = this.attendee_quota().val()
          this.previous_attendee_quota = value if value > 0
          this.attendee_quota().val(null)
          $(this.el).addClass("down")
          $(".attendee_quota_field").hide()
          $(".unlimited_attendee_quota").show()
      , =>
          this.attendee_quota().val(this.previous_attendee_quota)
          $(this.el).removeClass("down")
          $(".attendee_quota_field").show()
          $(".unlimited_attendee_quota").hide()
      )

    this

  render: -> this
#= require invite_people/invite_people
