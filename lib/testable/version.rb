module Testable
  module_function

  VERSION = "1.0.0".freeze
  public_constant :VERSION

  # Returns version information about Testable and its core dependencies.
  def version
    """
Testable v#{Testable::VERSION}
watir: #{gem_version('watir')}
selenium-webdriver: #{gem_version('selenium-webdriver')}
    """
  end

  # Returns a gem version for a given gem, assuming the gem has
  # been loaded.
  def gem_version(name)
    Gem.loaded_specs[name].version
  rescue NoMethodError
    puts "No gem loaded for #{name}."
  end

  # Returns all of the dependencies that Testable relies on.
  def dependencies
    Gem.loaded_specs.values.map { |spec| "#{spec.name} #{spec.version}\n" }
       .uniq.sort.join(",").split(",")
  end
end
