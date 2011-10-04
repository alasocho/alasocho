# A Las Ocho

## Setup

``` sh
$ bundle install
$ rake db:setup
$ bundle exec rspec spec
```

## Dependency on QT

If `bundle install` blows up for you with something about QT, it's because we're
using `capybara-webkit` for in-browser javascript testing in our acceptance
tests. You need to have QT bindings in your system to compile the
capybara-webkit gem. The latest instructions for getting this working should
always be available at: http://github.com/thoughtbot/capybara-webkit

## Tests

There are three different directories where tests are located:

    spec
    |- unit
    |- functional
    \- acceptance

Specs inside `unit` **must not** use rails. They should be true unit tests, use
mocks for collaborating objects, and never depend on *any* external dependency.
Not even rails. To that effect, you should require `unit_spec_helper` inside of
those, which only gives you regular rspec.

Specs inside `functional` get access to rails' testing harness. Here you can
test the integration of several models (and that the database works as you
expect, or test several variations on controllers depending on certain
parameters or if the user is logged in or not, etc).

Specs inside `acceptance` are expected to be browser tests. They get access to
capybara and all that.

The idea is that:

    amount of unit tests > amount of functional tests > amount of aceptance tests

And unit tests will be *fast*. Since they don't have to load rails, the startup
time for these should not go over 1 or 2 seconds, and the tests themselves
should be in the several hundreds per second range. If there's a slow unit test,
then either the code sucks and needs to be rewritten, or you're using something
external that you should be mocking.

## Offline

Right now we require the following external services:

* Authentication: Either Twitter, Facebook, or Google
* Geolocation: due to constraints of heroku, we [offloaded our geoip database
  lookups to an external service](http://geoip-service.herokuapp.com)

We should probably work on making the app better at working offline, so we can
work regardless of our connection status.
