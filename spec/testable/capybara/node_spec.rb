RSpec.describe Testable::Node do
  subject(:node) { Testable::Node }

  describe ".component" do
    it "raises an error without a subclass of Node" do
      expect {
        node.component(:test, String, "value")
      }.to raise_error(ArgumentError)
    end
  end

  describe ".components" do
    it "raises an error without a subclass of Node" do
      expect {
        node.components(:test, String, "value")
      }.to raise_error(ArgumentError)
    end
  end
end
