RSpec.describe Testable::Page do
  subject(:page) { Testable::Page.new(node: node, path: path) }
  let(:node) { double }
  let(:path) { "/test-page" }

  describe ".visit" do
    let(:page) { double }

    it "creates a new page instance and visits it" do
      expect(Testable::Page).to receive(:new).and_return(page)
      expect(page).to receive(:visit)
      Testable::Page.visit
    end
  end

  describe "#visit" do
    it "visits the page" do
      expect(node).to receive(:visit).with(path)
      page.visit
    end
  end

  describe "#current?" do
    it "returns true when the page is current" do
      expect(node).to receive(:current_path).and_return('/test-page')
      expect(page).to be_current
    end

    it "returns false when the page is not current" do
      expect(node).to receive(:current_path).and_return('/other-page')
      expect(page).to_not be_current
    end
  end
end
