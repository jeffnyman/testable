require "coveralls"
Coveralls.wear!

require "bundler/setup"
require "testable"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
])

SimpleCov.start do
  add_filter "spec/"
  coverage_dir "spec/coverage"
  minimum_coverage 80
  maximum_coverage_drop 5
end

Dir['spec/fixtures/**/*.rb'].each do |file|
  require file.sub(/spec\//, '')
end

RSpec.configure do |config|
  RSpec.shared_context :interface do
    let(:watir_browser) { mock_driver }
    let(:definition)    { ValidPage }
    let(:empty_page)    { EmptyPage.new(watir_browser) }
    let(:page)          { ValidPage.new(watir_browser) }
  end

  RSpec.shared_context :element do
    let(:watir_element) { double('element') }
  end

  config.alias_it_should_behave_like_to :provides_an, "when providing an"
end

RSpec.configure do |config|
  original_stderr = $stderr
  original_stdout = $stdout

  config.before(:all) do
    $stderr = File.new(File.join(File.dirname(__FILE__), "reports/testable-output.txt"), "a")
    $stdout = File.new(File.join(File.dirname(__FILE__), "reports/testable-output.txt"), "a")
  end

  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end

def clear_logger!
  return unless Testable.instance_variable_get(:@logger)
  Testable.remove_instance_variable(:@logger)
end

def capture_stdout
  original_stdout = $stdout
  $stdout = StringIO.new
  yield
  $stdout.string
ensure
  $stdout = original_stdout
end

def output_lines(string)
  string.split("\n").length
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = "spec/.rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
