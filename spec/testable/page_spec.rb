RSpec.describe Testable::Pages do
  include_context :interface
  include_context :element

  context "an instance of a page interface definition" do
    it "provides a definition API" do
      expect(page).to respond_to :definition_api
      expect(page.definition_api).to be_an_instance_of(Array)
    end

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

    it "verifies a secure page" do
      expect(watir_browser).to receive(:url).and_return("https://localhost:9292")
      expect(page.secure?).to be_truthy

      expect(watir_browser).to receive(:url).and_return("htts://localhost:9292")
      expect(page.secure?).to be_falsy
    end

    it "allows access to the markup of a page" do
      expect(watir_browser).to receive(:html).exactly(3).times.and_return("<h1>Page Section</h1>")
      expect(page.markup).to eq("<h1>Page Section</h1>")
      expect(page.html).to eq("<h1>Page Section</h1>")
      expect(page.html).to include("<h1>Page")
    end

    it "allows access to the text of a page" do
      expect(watir_browser).to receive(:text).exactly(3).times.and_return("some page text")
      expect(page.page_text).to eq("some page text")
      expect(page.text).to eq("some page text")
      expect(page.text).to include("page text")
    end

    it "runs a script against the browser" do
      expect(watir_browser).to receive(:execute_script).twice.and_return("input")
      expect(page.run_script("return document.activeElement")).to eq("input")
      expect(page.execute_script("return document.activeElement")).to eq("input")
    end

    it "runs a script, with arguments, against the browser" do
      expect(watir_browser).to receive(:execute_script).with("return arguments[0].innerHTML", watir_element).and_return("testing")
      expect(page.execute_script("return arguments[0].innerHTML", watir_element)).to eq("testing")
    end

    it "can return the screen width" do
      expect(watir_browser).to receive(:execute_script)
      page.screen_width
    end

    it "can return the screen height" do
      expect(watir_browser).to receive(:execute_script)
      page.screen_height
    end

    it "allows for calls to maximize the browser window" do
      expect(watir_browser).to receive(:resize_to).and_return(watir_browser)
      expect(watir_browser).to receive(:execute_script).twice.and_return(watir_browser)
      expect(watir_browser).to receive(:window).and_return(watir_browser)
      page.maximize
    end

    it "allows for calls to resize the browser window" do
      expect(watir_browser).to receive(:resize_to).and_return(watir_browser)
      expect(watir_browser).to receive(:window).and_return(watir_browser)
      page.resize_to(800, 800)
    end

    it "allows for calls to move the browser window" do
      expect(watir_browser).to receive(:move_to).and_return(watir_browser)
      expect(watir_browser).to receive(:window).and_return(watir_browser)
      page.move_to(0, 0)
    end

    it "refreshes the page" do
      expect(watir_browser).to receive(:refresh).twice.and_return(watir_browser)
      page.refresh_page
      page.refresh
    end

    it "gets a cookie value" do
      cookie = [{:name => 'test', :value => 'cookie', :path => '/'}]
      expect(watir_browser).to receive(:cookies).and_return(cookie)
      expect(page.get_cookie('test')).to eq('cookie')
    end

    it "returns nothing if a cookie value is not found" do
      cookie = [{:name => 'test', :value =>'cookie', :path => '/'}]
      expect(watir_browser).to receive(:cookies).and_return(nil)
      expect(page.get_cookie('testing')).to be_nil
    end

    it "clears all cookies from the browser" do
      expect(watir_browser).to receive(:cookies).twice.and_return(watir_browser)
      expect(watir_browser).to receive(:clear).twice
      page.remove_cookies
      page.clear_cookies
    end
  end
end
