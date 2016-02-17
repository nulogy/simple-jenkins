module SimpleJenkins
  class View
    include Virtus.value_object

    values do
      attribute :name, String
      attribute :description, String
      attribute :property, Array
      attribute :jobs, Array(Job)
      attribute :url, String
    end
  end
end
