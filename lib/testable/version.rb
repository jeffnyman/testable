module Testable
  module_function

  VERSION = "0.10.0".freeze

  def version
    """
Testable v#{Testable::VERSION}
watir: #{gem_version('watir')}
selenium-webdriver: #{gem_version('selenium-webdriver')}
capybara: #{gem_version('capybara')}
    """
  end

  def gem_version(name)
    Gem.loaded_specs[name].version
  rescue NoMethodError
    puts "No gem loaded for #{name}."
  end

  def dependencies
    Gem.loaded_specs.values.map { |spec| "#{spec.name} #{spec.version}\n" }
       .uniq.sort.join(",").split(",")
  end
end
