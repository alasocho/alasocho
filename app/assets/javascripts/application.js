//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require backbone-rails
//= require_self
//= require_tree ./a8

window.A8 = {
  "Models": {},
  "Collections": {},
  "Routers": {},
  "Views": {}
}

_.templateSettings = {
  interpolate: /\%\{(.+?)\}/g,
  evaluate:    /\[\[(.+?)\]\]/g
}

Date.prototype.isValid = function() {
  return this.getFullYear() || this.getFullYear() === 0;
}

jQuery(function($) {
  $(document).keyup(function(event){
    if (event.keyCode == 27) { // ESC
      $("#notifications").hide();
    }
  });

  $('#notifications_link').click(function(ev) {
    $("#notifications").toggle();
    $(this).blur();
    return false;
  });
});
