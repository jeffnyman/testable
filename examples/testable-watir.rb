#!/usr/bin/env ruby
$LOAD_PATH << "./lib"

require "rspec"
# rubocop:disable Style/MixinUsage
include RSpec::Matchers
# rubocop:enable Style/MixinUsage

require "testable"

class Home
  include Testable

  url_is "https://veilus.herokuapp.com/"
end

Testable.start_browser :firefox

page = Home.new

# You can specify a URL to visit or you can rely on the provided
# url_is attribute on the page definition. So you could do this:
# page.visit("https://veilus.herokuapp.com/")
page.visit

expect(page.url).to eq(page.url_attribute)

Testable.quit_browser
