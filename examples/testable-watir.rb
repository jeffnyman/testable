#!/usr/bin/env ruby
$LOAD_PATH << "./lib"

require "rspec"
include RSpec::Matchers

require "testable"

class Home
  include Testable

  url_is "https://veilus.herokuapp.com/"
end

Testable.start_browser :firefox

page = Home.new

Testable.quit_browser
