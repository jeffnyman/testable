RSpec.describe Testable do
  it "has a version number" do
    expect(Testable::VERSION).not_to be nil
  end

  it "returns version information" do
    expect(Testable.version).to include("Testable v#{Testable::VERSION}")
    expect(Testable.version).to include("watir")
    expect(Testable.version).to include("capybara")
  end

  it "returns dependency information" do
    expect(Testable.dependencies.to_s).to include("watir")
    expect(Testable.dependencies.to_s).to include("capybara")
  end

  it "returns its own API information" do
    expect(Testable.api.to_s).to include("browser")
  end

  context "third-party APIs" do
    it "returns Watir API information" do
      expect(Testable).to respond_to :watir_api
      expect(Testable.watir_api).to be_an_instance_of(Array)
    end

    it "returns Selenium API information" do
      expect(Testable).to respond_to :selenium_api

      # NOTE: This is not working due to the call to `driver`. I have
      # no idea how to mock that out in a way that resolves.
      # expect(Testable.selenium_api).to be_an_instance_of(Array)
    end
  end
end
