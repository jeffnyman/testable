#!/usr/bin/env ruby
$LOAD_PATH << "./lib"

require "testable"

require "rspec"
include RSpec::Matchers

puts Testable::VERSION

puts "================================="
puts "Testable's Version"
puts "================================="
puts Testable.version

puts "================================="
puts "Testable's Dependencies"
puts "================================="
puts Testable.dependencies

puts "================================="
puts "Testable's API"
puts "================================="
puts Testable.api

class Home
  include Testable
end

Testable.start_browser :firefox, headless: true

page = Home.new

expect(Testable.browser).to be_an_instance_of(Watir::Browser)
expect(Testable.browser.driver).to be_an_instance_of(Selenium::WebDriver::Firefox::Marionette::Driver)

expect(page).to be_a_kind_of(Testable)
expect(page).to be_an_instance_of(Home)

puts "================================="
puts "Cogent's Watir API"
puts "================================="
puts Testable.watir_api

puts "================================="
puts "Cogent's Selenium API"
puts "================================="
puts Testable.selenium_api

Testable.quit_browser
