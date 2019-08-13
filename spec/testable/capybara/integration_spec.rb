class Header < Testable::Node
  element :title, 'h1'
end

class Label < Testable::Node
  def required?
    node[:class].include?('required')
  end
end

class Field < Testable::Node
  component :label, Label, 'label'
  element :input, 'input'
end

class Form < Testable::Node
  components :fields, Field, 'div'
  element :button, 'button'
end

class TestPage < Testable::Page
  component :header, Header, 'header'
  component :form, Form, 'form'

  def path
    '/page.html'
  end

  def login(username, password)
    fill_in 'Username', with: username
    fill_in 'Password', with: password
    form.button.click
  end
end

RSpec.describe TestPage do
  subject(:page) { TestPage.visit }

  before do
    Capybara.app = Rack::File.new(File.expand_path("../../fixtures/html", __dir__))
  end

  it "has a header" do
    expect(page).to have_header
    expect(page.header.title.text).to eq("Login")
  end

  it "has a form" do
    expect(page.form).to have_fields
    expect(page.form.fields.count).to be(2)

    expect(page.form.fields[0].label.text).to eq("Username")
    expect(page.form.fields[0].label).to be_required
    expect(page.form.fields[0].input.value).to be_nil

    expect(page.form.fields[1].label.text).to eq("Password")
    expect(page.form.fields[1].input.value).to be_nil

    expect(page.form).to have_button
    expect(page.form.button.text).to eq("Login")
  end

  it "can log in" do
    page.login('admin', 'admin')
  end
end
