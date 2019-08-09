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

  p          :login_form, id: "open", visible: true
  text_field :username,   id: "username"
  text_field :password
  button     :login,      id: "login-button"
  div        :message,    class: 'notice'

  def begin_with
    move_to(0, 0)
    resize_to(screen_width, screen_height)
  end
end

class WarpTravel
  include Testable

  url_is "https://veilus.herokuapp.com/warp"

  text_field :warp_factor, id: 'warpInput'
  text_field :velocity,    id: 'velocityInput'
  text_field :distance,    id: 'distInput'
end

Testable.start_browser :firefox

on_visit(Home) do
  @active.login_form.click
  @active.username.set "admin"
  @active.password(id: 'password').set "admin"
  @active.login.click
end

on_visit(WarpTravel).using_data("warp factor": 1, velocity: 1, distance: 4.3)

Testable.quit_browser
