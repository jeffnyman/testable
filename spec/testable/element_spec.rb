RSpec.shared_examples_for "element method for" do |elements|
  elements.each do |element|
    context "#{element} on the watir platform" do
      # Need to determine how to best use this test with the regions.
      xit "will locate a specific #{element} with a single locator" do
        allow(watir_element).to receive(:to_subtype).and_return(watir_element)
        expect(watir_browser).to receive(element).with(id: element).and_return(watir_element)
        expect(page.send "#{element}").to eq(watir_element)
      end

      it "will locate a specific #{element} with a proc" do
        expect(watir_browser).to receive(element).with(id: element).and_return(watir_element)
        expect(page.send "#{element}_proc").to eq(watir_element)
      end

      it "will locate a specific #{element} with a lambda" do
        expect(watir_browser).to receive(element).with(id: element).and_return(watir_element)
        expect(page.send "#{element}_lambda").to eq(watir_element)
      end

      it "will locate a specific #{element} with a block" do
        expect(watir_browser).to receive(element).with(id: element).and_return(watir_element)
        expect(page.send "#{element}_block", element).to eq(watir_element)
      end

      it "will locate a specific #{element} with a block and argument" do
        expect(watir_browser).to receive(element).with(id: element).and_return(watir_element)
        expect(page.send "#{element}_block_arg", element).to eq(watir_element)
      end

      it "will use a subtype for an element locator" do
        if element == 'element'
          allow(watir_element).to receive(:to_subtype).and_return(watir_element)
          expect(watir_browser).to receive(element).with(id: element).and_return(watir_element)
          expect(page.send "#{element}").to eq(watir_element)
        end
      end
    end
  end
end

RSpec.describe Testable::Pages::Element do
  include_context :interface
  include_context :element

  provides_an "element method for", %w{text_field button buttons file_field textarea select_list checkbox p div link element}

  it "provides a way to get a list of accepted elements" do
    expect(Testable.elements?).to include(:textarea)
  end

  it "provides a way to check if an element is recognized" do
    expect(Testable.recognizes?("div")).to be_truthy
  end
end
