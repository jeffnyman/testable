class ValidPage
  include Testable

  url_is "http://localhost:9292"
  title_is "Veilus"
end

class EmptyPage
  include Testable
end
