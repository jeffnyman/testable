class ValidPage
  include Testable

  url_is "http://localhost:9292"
end

class EmptyPage
  include Testable
end
