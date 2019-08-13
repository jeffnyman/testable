#!/usr/bin/env rake
require "bundler/gem_tasks"

require "rdoc/task"
require "rubocop/rake_task"
require "rspec/core/rake_task"

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec)

namespace :script_testable do
  desc "Run the Testable info script"
  task :info do
    system("ruby ./examples/testable-info.rb")
  end
end

namespace :script_capybara do
  desc "Run the Testable Capybara script"
  task :capybara do
    system("ruby ./examples/testable-capybara.rb")
  end

  desc "Run the Testable Capybara context script"
  task :context do
    system("ruby ./examples/testable-capybara-context.rb")
  end
end

namespace :script_watir do
  desc "Run the Testable Watir script"
  task :watir do
    system("ruby ./examples/testable-watir.rb")
  end

  desc "Run the Testable Watir example test"
  task :test do
    system("ruby ./examples/testable-watir-test.rb")
  end

  desc "Run the Testable Watir context script"
  task :context do
    system("ruby ./examples/testable-watir-context.rb")
  end

  desc "Run the Testable Watir events script"
  task :events do
    system("ruby ./examples/testable-watir-events.rb")
  end

  desc "Run the Testable Watir ready script"
  task :ready do
    system("ruby ./examples/testable-watir-ready.rb")
  end

  desc "Run the Testable Watir data setter script"
  task :dataset do
    system("ruby ./examples/testable-watir-datasetter.rb")
  end
end

namespace :spec do
  desc 'Clean all generated reports'
  task :clean do
    system('rm -rf spec/reports')
    system('rm -rf spec/coverage')
  end

  RSpec::Core::RakeTask.new(all: :clean) do |config|
    options  = %w[--color]
    options += %w[--format documentation]
    options += %w[--format html --out spec/reports/unit-test-report.html]

    config.rspec_opts = options
  end
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.main = 'README.md'
  rdoc.title = "Testable #{Testable::VERSION}"
  rdoc.rdoc_files.include('README*', 'lib/**/*.rb')
end

task default: ['spec:all', :rubocop]
