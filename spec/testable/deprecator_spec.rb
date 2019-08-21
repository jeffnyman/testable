RSpec.describe Testable::Deprecator do
  before { clear_logger! }

  context "deprecating a feature" do
    it "generates warning messages" do
      log_messages = capture_stdout do
        Testable.log_level = :WARN
        described_class.deprecate("current", "upcoming", "known_version")
      end

      expect(output_lines(log_messages)).to eq 2
    end

    it "requires a `current` argument" do
      expect { described_class.deprecate }
        .to raise_error(ArgumentError)
        .with_message("wrong number of arguments \(given 0, expected 1..3\)")
    end
  end

  context "soft deprecatation of a feature" do
    it "generates warning messages" do
      log_messages = capture_stdout do
        Testable.log_level = :DEBUG
        described_class.soft_deprecate("current", "reason", "known_version", "upcoming")
      end

      expect(output_lines(log_messages)).to eq 4
    end

    it "requires a `current`, `reason` and `known_version` argument" do
      expect { described_class.soft_deprecate }
        .to raise_error(ArgumentError)
        .with_message("wrong number of arguments \(given 0, expected 3..4\)")
    end
  end
end
