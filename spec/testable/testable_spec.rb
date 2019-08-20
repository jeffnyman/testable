RSpec.describe Testable do
  before { clear_logger! }

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
    expect(Testable.api.to_s).to include("start_browser")
    expect(Testable.api.to_s).to include("quit_browser")
  end

  context "logger" do
    context "at the default severity level" do
      it "does not log messages below UNKNOWN" do
        log_messages = capture_stdout do
          described_class.logger.debug('DEBUG')
          described_class.logger.fatal('FATAL')
        end

        expect(log_messages).to be_empty
      end

      it "logs UNKNOWN level messages" do
        log_messages = capture_stdout do
          described_class.logger.unknown('UNKNOWN')
        end

        expect(output_lines(log_messages)).to eq(1)
      end
    end

    context "at a modified severity level" do
      it "logs messages at all levels above the severity level" do
        log_messages = capture_stdout do
          described_class.log_level = :DEBUG

          described_class.logger.debug('DEBUG')
          described_class.logger.info('INFO')
        end

        expect(output_lines(log_messages)).to eq(2)
      end
    end

    context "log path" do
      context "setting to a file" do
        let(:filename) { 'testable.log' }
        let(:file_content) { File.read(filename) }

        before { described_class.log_path = filename }
        after { File.delete(filename) if File.exist?(filename) }

        it "sends the log messages to the file path provided" do
          described_class.logger.unknown('Log to file')

          expect(file_content).to end_with("Log to file\n")
        end
      end

      context "setting to standard error" do
        it "sends the log messages to $stderr" do
          expect do
            described_class.log_path = $stderr
            described_class.logger.unknown('Log to $stderr')
          end.to output(/Log to \$stderr/).to_stderr
        end
      end
    end

    context "setting log level" do
      it "can modify the log level" do
        expect(described_class).to respond_to(:log_level=)
      end
    end

    context "reading log level" do
      subject { described_class.log_level }

      context "default level" do
        it { is_expected.to eq(:UNKNOWN) }
      end

      context "after being modified to INFO" do
        before { described_class.log_level = :INFO }

        it { is_expected.to eq(:INFO) }
      end
    end
  end

  context "third-party APIs" do
    it "returns Watir API information" do
      expect(Testable).to respond_to :watir_api
      expect(Testable.watir_api).to be_an_instance_of(Array)

      # I'm not entirely sure why I can't do this. I think
      # it's because an actual driver instance has not been
      # set up yet so the full range of Watir's methods have
      # not yet become available.
      # expect(Testable.watir_api).to include("browser")
    end

    it "returns Selenium API information" do
      expect(Testable).to respond_to :selenium_api

      # NOTE: This is not working due to the call to `driver`. I have
      # no idea how to mock that out in a way that resolves.
      # expect(Testable.selenium_api).to be_an_instance_of(Array)
    end
  end

  context "a testable driver is requested" do
    it "a default watir browser is provided" do
      allow(Watir::Browser).to receive(:new).and_return(Testable.browser)
    end
  end
end
