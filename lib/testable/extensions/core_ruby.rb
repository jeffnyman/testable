# rubocop:disable Style/DocumentationMethod

class String
  # This is only required if using a version of Ruby before 2.4. A match?
  # method for String was added in version 2.4.
  def match?(string, pos = 0)
    !!match(string, pos)
  end unless //.respond_to?(:match?)
end

class FalseClass
  def exists?
    false
  end
end

# rubocop:enable Style/DocumentationMethod
