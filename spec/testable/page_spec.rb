RSpec.describe Testable::Pages do
  include_context :interface

  context "an instance of a page interface definition" do
    it "provides a url_attribute for a url_is value" do
      expect(page).to respond_to :url_attribute
      expect(page.url_attribute).to eq("http://localhost:9292")
    end

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

    it "provides a url_match_attribute for a url_matches value" do
      expect(page).to respond_to :url_match_attribute
      expect(page.url_match_attribute).to eq(/:\d{4}/)
    end

    it "verifies a url if the url_matches assertion has been set" do
      expect(watir_browser).to receive(:url).twice.and_return("http://localhost:9292")
      expect { page.has_correct_url? }.not_to raise_error
      expect(page.has_correct_url?).to be_truthy
    end

    it "does not verify a url if the url does not match the url_matches assertion" do
      expect(watir_browser).to receive(:url).and_return("http://127.0.0.1")
      expect(page.has_correct_url?).to be_falsey
    end

    it "checks if a page is displayed" do
      expect(watir_browser).to receive(:url).twice.and_return("http://localhost:9292")
      page.displayed?
      page.loaded?
    end

    it "provides a title_attribute for a title_is value" do
      expect(page).to respond_to :title_attribute
      expect(page.title_attribute).to eq("Veilus")
    end

    it "allows access to the title of a page" do
      expect(watir_browser).to receive(:title).exactly(3).times.and_return("Veilus")
      expect(page).to respond_to :title
      expect(page.page_title).to eq("Veilus")
      expect(page.title).to eq("Veilus")
      expect(page.title).to include("Veil")
    end

    it "verifies a title if the title_is assertion has been set" do
      expect(watir_browser).to receive(:title).twice.and_return "Veilus"
      expect { page.has_correct_title? }.not_to raise_error
      expect(page.has_correct_title?).to be_truthy
    end

    it "does not verify a title if the title does not match the title_is assertion" do
      expect(watir_browser).to receive(:title).and_return("Page Title")
      expect(page.has_correct_title?).to be_falsey
    end

    it "provides an exception when no title is provided and and a title check is attempted" do
      expect { empty_page.has_correct_title? }.to raise_error Testable::Errors::NoTitleForDefinition
    end
  end
end
