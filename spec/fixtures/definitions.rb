class ValidPage
  include Testable

  url_is "http://localhost:9292"
  url_matches /:\d{4}/
  title_is "Veilus"
end

class EmptyPage
  include Testable
end
