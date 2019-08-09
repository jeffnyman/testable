RSpec.describe Testable::Pages::Attribute do
  include_context :interface

  context "a page definition" do
    it "allows a url_is attribute" do
      expect(definition).to respond_to :url_is
    end

    it "allows a url_attribute attribute" do
      expect(definition).to respond_to :url_attribute
    end

    it "provides no default url" do
      expect(empty_page.url_attribute).to be_nil
    end

    it "does not allow an empty url_is attribute" do
      expect {
        class PageWithEmptyUrlIs
          include Testable
          url_is
        end
      }.to raise_error Testable::Errors::NoUrlForDefinition
    end
  end
end
