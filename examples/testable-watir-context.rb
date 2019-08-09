#!/usr/bin/env ruby
$LOAD_PATH << "./lib"

require "rspec"
# rubocop:disable Style/MixinUsage
include RSpec::Matchers
# rubocop:enable Style/MixinUsage

require "testable"
# rubocop:disable Style/MixinUsage
include Testable::Context
# rubocop:enable Style/MixinUsage

class Home
  include Testable

  url_is "https://veilus.herokuapp.com/"
  url_matches(/heroku/)
  title_is "Veilus"

  # Elements can be defined with HTML-style names as found in Watir.
  p          :login_form, id:    "open", visible: true
  text_field :username,   id:    "username"
  text_field :password
  button     :login,      id:    "login-button"
  div        :message,    class: "notice"

  # Elements can be defined with a generic name.
  # element :login_form, id:    "open", visible: true
  # element :username,   id:    "username"
  # element :password
  # element :login,      id:    "login-button"
  # element :message,    class: "notice"

  def begin_with
    move_to(0, 0)
    resize_to(screen_width, screen_height)
  end
end

class Navigation
  include Testable

  p     :page_list,     id: "navlist"
  link  :planets,       id: "planets"

  image :planet_logo,   id: "planet-logo"
end

Testable.start_browser :firefox

on_visit(Home) do
  @active.login_form.click
  @active.username.set "admin"
  @active.password(id: 'password').set "admin"
  @active.login.click
  expect(@active.message.text).to eq('You are now logged in as admin.')
end

on(Navigation) do |page|
  page.page_list.click
  # page.page_list.wait_until(&:dom_updated?).click
  page.planets.click
  expect(page.planet_logo.exists?).to be true
end

Testable.quit_browser
