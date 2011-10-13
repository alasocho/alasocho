require "spec_helper"

$LOAD_PATH.unshift("./app/models")

Dir["./spec/support/no_rails/**/*.rb"].each {|f| require f }
