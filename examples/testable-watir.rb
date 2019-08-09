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

expect(page.html.include?('<article id="index">')).to be_truthy
expect(page.text.include?("Running a Local Version")).to be_truthy

page.login_form.click
page.username.set "admin"
page.password(id: 'password').set "admin"
page.login.click
expect(page.message.text).to eq('You are now logged in as admin.')

page.run_script("alert('Testing');")

expect(page.browser.alert.exists?).to be_truthy
expect(page.browser.alert.text).to eq("Testing")
page.browser.alert.ok
expect(page.browser.alert.exists?).to be_falsy

# You have to sometimes go down to Selenium to do certain things with
# the browser. Here the browser (which is a Watir Browser) that is part
# of the definition (page) is referencing the driver (which is a Selenium
# Driver) and is then calling into the `manage` subsystem, which gives
# access to the window.
page.browser.driver.manage.window.minimize

# Sleeps are a horrible thing. But they are useful for demonstrations.
# In this case, the sleep is there just to let you see that the browser
# did minimize before it gets maximized.
sleep 2

page.maximize

# Another brief sleep just to show that the maximize did fact work.
sleep 2

page.resize_to(640, 480)

# A sleep to show that the resize occurs.
sleep 2

page.move_to(page.screen_width / 2, page.screen_height / 2)

# A sleep to show that the move occurs.
sleep 2

page.screenshot("testing.png")

Testable.quit_browser
