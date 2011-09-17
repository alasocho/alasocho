class A8.Models.Invitation extends Backbone.Model
  @email_regexp = /\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i
  email_regexp: @email_regexp

  validate: (attrs) ->
    unless attrs.email?.match(@email_regexp)
      return "Doesn't look like an email"
