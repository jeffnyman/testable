RSpec.describe "DOM Observer Extension", :skip do
  before(:all) do
    @browser = Watir::Browser.new(:firefox)
  end

  before(:each) do
    @browser.goto "data:text/html,#{File.read("spec/fixtures/html/dom.html")}"
  end

  after(:each) do |example|
    @browser.refresh
  end

  after(:all) do
    @browser.quit
  end

  context "when the DOM is updated" do
    context "when a context block is not provided" do
      it "waits using the mutation observer" do
        @browser.button(id: "quick").click
        expect(@browser.div.wait_until(&:dom_updated?).spans.count).to eq(19)
      end

      it "is able to wait on a custom interval in JavaScript" do
        @browser.button(id: "long").click
        expect(@browser.div.wait_until(&:dom_updated?).spans.count).to eq(5)
      end

      it "will raise a timeout error" do
        @browser.button(id: "quick").click
        expect { @browser.div.wait_until(timeout: 1, &:dom_updated?) }.to raise_error(Watir::Wait::TimeoutError)
      end

      # Fragile test. Determine why.
      # context "when run more than one time" do
      #   it "waits for the DOM to update consecutively" do
      #     3.times do |i|
      #       sleep 1
      #       @browser.button(id: "quick").click
      #       expect(@browser.div.wait_until(&:dom_updated?).spans.count).to eq(20 * (i + 1))
      #     end
      #   end
      # end
    end
  end

  context "when the DOM is not updated" do
    it "will not raise any exception" do
      expect(@browser.div.wait_until(&:dom_updated?).spans.count).to eq(0)
    end
  end

  context "when JavaScript effects are used" do
    it "will properly handle fading" do
      @browser.button(id: 'fade').click
      text = @browser.div(id: 'container3').wait_until(&:dom_updated?).span.text
      expect(text).to eq('Faded')
    end
  end

  context "when an element goes stale" do
    it "will relocate the element" do
      @browser.button(id: 'stale').click
      expect { @browser.div(id: 'container2').wait_until(&:dom_updated?) }.not_to raise_error
    end
  end

  context "when an element cannot be located" do
    it "will raise an error" do
      div = @browser.div(id: 'doesnotexist')
      expect { div.wait_until(&:dom_updated?) }.to raise_error(Watir::Exception::UnknownObjectException)
    end
  end
end
