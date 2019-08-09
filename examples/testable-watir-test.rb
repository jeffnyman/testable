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

page = Home.new

page.visit

page.login_form.click
page.username.set "admin"
page.password(id: 'password').set "admin"
page.login.click
expect(page.message.text).to eq('You are now logged in as admin.')

page = Navigation.new

page.page_list.click
# page.page_list.wait_until(&:dom_updated?).click

page.planets.click
expect(page.planet_logo.exists?).to be true

Testable.quit_browser
