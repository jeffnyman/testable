#!/usr/bin/env ruby
$LOAD_PATH << "./lib"

require "rspec"
include RSpec::Matchers

require "testable"

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium
  config.app_host = "https://veilus.herokuapp.com"
end

class HomePage < Testable::Page
  element :login_form, "#open"
  element :username,   "#username"
  element :password,   "#password"
  element :login,      "#login-button"

  def path
    "/"
  end
end

home_page = HomePage.visit

puts home_page.current?
expect(home_page).to be_current

puts home_page.find("article").text

puts home_page.login_form.inspect

puts home_page.has_login_form?
puts home_page.has_no_login_form?

expect(home_page).to have_login_form

# The next statement would (correctly) fail.
# expect(home_page).to have_no_login_form

home_page.login_form.click
home_page.username.set "admin"
home_page.password.set "admin"
home_page.login.click
