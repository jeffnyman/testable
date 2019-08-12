RSpec.describe Testable::Context do
  include_context :interface
  include Testable::Context

  before(:each) do
    @factory = TestFactory.new
    @factory.browser = mock_driver
  end

  context "on visit" do
    it "creates a new definition and executes a block in the created execution context" do
      expect(@active).to receive(:goto)
      expect(@active).to receive(:url).and_return "http://localhost:9292"
      @factory.on_visit ValidPage do |page|
        expect(page).to be_instance_of ValidPage
      end
    end
  end

  context "on" do
    it "creates a new definition and executes a block in the existing execution context" do
      @factory.on ValidPage do |page|
        expect(page).to be_instance_of ValidPage
      end
    end

    it "provides a context reference to be used outside the context" do
      page = @factory.on ValidPage
      current = @factory.instance_variable_get '@context'
      expect(current).to be(page)
    end

    it "uses an existing object reference with on" do
      obj1 = @factory.on ValidPage
      obj2 = @factory.on ValidPage
      expect(obj1).to be(obj2)
    end
  end

  context "verification during context" do
    it "raises an exception for url not matching" do
      expect(@active).to receive(:goto)
      expect(@active).to receive(:url).and_return "http://example.com"
      expect {
        @factory.on_visit(ValidPage)
      }.to raise_error(
        Testable::Errors::PageURLFromFactoryNotVerified,
        "The page URL was not verified during a factory setup.")
    end
  end
end
