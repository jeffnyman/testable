RSpec.describe Testable::Pages::Attribute do
  include_context :interface

  context "a page definition" do
    it "allows a url_is attribute" do
      expect(definition).to respond_to :url_is
    end
  end
end
