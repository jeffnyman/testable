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

Testable.start_browser :firefox, headless: true

expect(Testable.browser).to be_an_instance_of(Watir::Browser)
expect(Testable.browser.driver).to be_an_instance_of(Selenium::WebDriver::Firefox::Marionette::Driver)

Testable.quit_browser
