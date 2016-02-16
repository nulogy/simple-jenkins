module SimpleJenkins
  class Response
    include Virtus.value_object

    values do
      attribute :code, Integer
      attribute :message, String
    end

    def success?
      code >= 200 && code < 300
    end
  end
end