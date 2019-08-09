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

    it "allows a url_match_attribute attribute" do
      expect(definition).to respond_to :url_match_attribute
    end

    it "provides no default url matcher" do
      expect(empty_page.url_match_attribute).to be_nil
    end

    it "does not allow an empty url_matches attribute" do
      expect {
        class PageWithEmptyUrlMatches
          include Testable
          url_matches
        end
      }.to raise_error Testable::Errors::NoUrlMatchForDefinition
    end

    it "does not verify a url if the url_matches attribute has not been set" do
      expect {
        empty_page.has_correct_url?
      }.to raise_error Testable::Errors::NoUrlMatchPossible
    end

    it "allows a title_attribute attribute" do
      expect(definition).to respond_to :title_attribute
    end

    it "provides no default title" do
      expect(empty_page.title_attribute).to be_nil
    end

    it "does not verify a title if the title_is attribute has not been set" do
      expect {
        empty_page.has_correct_title?
      }.to raise_error Testable::Errors::NoTitleForDefinition
    end

    it "does not allow an empty title_is attribute" do
      expect {
        class PageWithEmptyTitleIs
          include Testable
          title_is
        end
      }.to raise_error Testable::Errors::NoTitleForDefinition
    end
  end
end
