# rubocop:disable Style/DocumentationMethod
module Testable
  module Errors
    NoUrlForDefinition = Class.new(StandardError)
    NoUrlMatchForDefinition = Class.new(StandardError)
    NoUrlMatchPossible = Class.new(StandardError)
    NoTitleForDefinition = Class.new(StandardError)
    PageNotValidatedError = Class.new(StandardError)
    PluralizedElementError = Class.new(StandardError)
    RegionNamespaceError = Class.new(StandardError)
    RegionFinderError = Class.new(StandardError)

    public_constant :NoUrlForDefinition
    public_constant :NoUrlMatchForDefinition
    public_constant :NoUrlMatchPossible
    public_constant :NoTitleForDefinition
    public_constant :PageNotValidatedError
    public_constant :PluralizedElementError
    public_constant :RegionNamespaceError
    public_constant :RegionFinderError

    class PageURLFromFactoryNotVerified < StandardError
      def message
        "The page URL was not verified during a factory setup."
      end
    end
  end
end
# rubocop:enable Style/DocumentationMethod
