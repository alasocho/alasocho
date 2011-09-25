require "spec_helper"

$LOAD_PATH.unshift("./app/models")

Dir["./spec/support/unit/**/*.rb"].each {|f| require f }
