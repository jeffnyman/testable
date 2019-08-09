#!/usr/bin/env ruby
$LOAD_PATH << "./lib"

require "rspec"
# rubocop:disable Style/MixinUsage
include RSpec::Matchers
# rubocop:enable Style/MixinUsage

require "testable"

class Dynamic
  include Testable

  url_is "https://veilus.herokuapp.com/practice/dynamic_events"

  button :long,  id: 'long'
  button :quick, id: 'quick'
  button :stale, id: 'stale'
  button :fade,  id: 'fade'

  div :dom_events,    id: 'container1'
  div :stale_event,   id: 'container2'
  div :effect_events, id: 'container3'
end

Testable.start_browser :firefox

page = Dynamic.new

page.visit

expect(page.dom_events.dom_updated?).to be_truthy
expect(page.dom_events.wait_until(&:dom_updated?).spans.count).to eq(0)

page.long.click

expect(page.dom_events.dom_updated?).to be_falsey
expect(page.dom_events.wait_until(&:dom_updated?).spans.count).to eq(4)

page.quick.click

expect(page.dom_events.wait_until(&:dom_updated?).spans.count).to eq(23)

Testable.quit_browser
