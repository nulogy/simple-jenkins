require 'virtus'

module SimpleJenkins
  class JobGroup
    include Virtus.value_object

    values do
      attribute :name, String
      attribute :description, String
      attribute :params, Hash
      attribute :job_names, Array(String)
      attribute :notify, String
    end
  end
end