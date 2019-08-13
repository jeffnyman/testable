#!/usr/bin/env ruby
$LOAD_PATH << "./lib"

require "rspec"
include RSpec::Matchers

require "testable"
include Testable::Context

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

class MenuItem < Testable::Node
  components :items, Navigation, "#areas"
end

class LandingPage < Testable::Page
  component :navigation, Navigation, "#areas"
  element :logo, "#site-image"
end

on_visit(HomePage).login_as_admin

on(LandingPage) do |action|
  action.navigation.page_list.click
  puts action.navigation.overlord.text
  puts action.navigation.items
  puts action.navigation.items[0].text
  expect(action.navigation).to have_items
  expect(action.navigation.items[0].text).to eq("Home")
  expect(action.navigation.items.count).to be(8)
  action.navigation.overlord.click
end
