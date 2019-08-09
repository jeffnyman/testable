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
  p          :login_form, id: "open", visible: true
  text_field :username,   id: "username"
  text_field :password
  button     :login,      id: "login-button"
  div        :message,    class: 'notice'

  # Elements can be defined with a generic name.
  # element :login_form, id: "open", visible: true
  # element :username,   id: "username"
  # element :password
  # element :login,      id: "login-button"
end

Testable.start_browser :firefox

page = Home.new

# You can specify a URL to visit or you can rely on the provided
# url_is attribute on the page definition. So you could do this:
# page.visit("https://veilus.herokuapp.com/")
page.visit

expect(page.url).to eq(page.url_attribute)
expect(page.url).to match(page.url_match_attribute)
expect(page.title).to eq(page.title_attribute)

expect(page.has_correct_url?).to be_truthy
expect(page).to have_correct_url

expect(page.displayed?).to be_truthy
expect(page).to be_displayed

expect(page.has_correct_title?).to be_truthy
expect(page).to have_correct_title

expect(page.secure?).to be_truthy
expect(page).to be_secure

page.login_form.click
page.username.set "admin"
page.password(id: 'password').set "admin"
page.login.click
expect(page.message.text).to eq('You are now logged in as admin.')

Testable.quit_browser
