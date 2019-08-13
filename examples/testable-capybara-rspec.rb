#!/usr/bin/env ruby
$LOAD_PATH << "./lib"

# Run this with:
# rspec ./examples/testable-capybara-rspec.rb

require "rspec"
include RSpec::Matchers

require "testable"
include Testable::Context

require "capybara/rspec"

RSpec.configure do |config|
  config.expose_dsl_globally = true
end

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

  def login_as_admin
    login_form.click
    username.set "admin"
    password.set "admin"
    login.click
  end
end

class Navigation < Testable::Node
  elements :items, "a"

  element :page_list, "#navlist"
  element :overlord,  "#overlord"
  element :planets,   "#planets"
  element :warp,      "#warp"
  element :stardate,  "#stardate"
end

class LandingPage < Testable::Page
  component :navigation, Navigation, "#areas"

  def go_to_overlord
    navigation.page_list.click
    navigation.overlord.click
  end
end

feature "navigation" do
  background do
    on_visit(HomePage).login_as_admin
  end

  scenario "navigates to overlord" do
    on(LandingPage).go_to_overlord
  end
end
