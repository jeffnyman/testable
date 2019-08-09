#!/usr/bin/env ruby
$LOAD_PATH << "./lib"

require "rspec"
# rubocop:disable Style/MixinUsage
include RSpec::Matchers
# rubocop:enable Style/MixinUsage

require "testable"

class PageReady
  include Testable

  url_is "https://veilus.herokuapp.com"

  element :logo, id: 'site-'
  element :login_form, id: 'openski'

  page_ready { [logo.exists?, "Test Gorilla logo is not present"] }
end

Testable.start_browser :firefox

page = PageReady.new

page.visit

# Uncomment one of these at a time to see that the page_ready part
# is working. The element definitions above are purposely incorrect.

# page.when_ready { page.login_form.click }
# page.login_form.click

Testable.quit_browser
