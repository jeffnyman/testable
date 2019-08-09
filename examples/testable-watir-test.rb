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

Testable.start_browser :firefox

page = Home.new

page.visit

Testable.quit_browser
