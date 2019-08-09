RSpec.describe Testable::Pages do
  include_context :interface

  context "an instance of a page interface definition" do
    it "allows navigation to a page based on explicit url" do
      expect(watir_browser).to receive(:goto).exactly(5).times
      page.perform('http://localhost:9292')
      page.navigate_to('http://localhost:9292')
      page.goto('http://localhost:9292')
      page.view('http://localhost:9292')
      page.visit('http://localhost:9292')
    end

    it "allows navigation to a page based on the url_is attribute" do
      expect(watir_browser).to receive(:goto).exactly(5).times
      page.perform
      page.navigate_to
      page.goto
      page.view
      page.visit
    end

    it "provides an exception when no url is provided and a visit is attempted" do
      expect { empty_page.visit }.to raise_error Testable::Errors::NoUrlForDefinition
    end

    it "allows access to the url of the page" do
      expect(watir_browser).to receive(:url).exactly(3).times.and_return("http://localhost:9292")
      expect(page).to respond_to :url
      expect(page.current_url).to eq("http://localhost:9292")
      expect(page.page_url).to eq("http://localhost:9292")
      expect(page.url).to eq("http://localhost:9292")
    end
  end
end
