require 'virtus'
require 'uri'

module SimpleJenkins
  class ParameterDefinition
    include Virtus.value_object

    values do
      attribute :name, String
      attribute :description, String
      attribute :type, String
      attribute :defaultParameterValue, Hash
    end
  end

  class Build
    include Virtus.value_object

    values do
      attribute :number, Integer
      attribute :url, String
      attribute :result, String
      attribute :building, Boolean
    end

    def success?
      result == 'SUCCESS'
    end

    def failure?
      result == 'FAILURE'
    end

    def building?
      building
    end
  end

  class Job
    include Virtus.value_object

    values do
      attribute :name, String
      attribute :url, String
      attribute :color, String

      # attribute :actions, { parameterDefinitions: [ParameterDefinition] }
      attribute :buildable, Boolean
      attribute :builds, [Build]

      attribute :concurrentBuild, Boolean
      attribute :description, String
      attribute :displayName, String
      attribute :displayNameOrNull, String
      attribute :downstreamProjects, Array
      attribute :firstBuild, Build
      # attribute :healthReport, { description: String, iconClassName: String, iconUrl: String, score: Integer }
      attribute :inQueue, Boolean
      attribute :lastDependencies, Boolean

      attribute :lastBuild, Build
      attribute :lastCompletedBuild, Build
      attribute :lastFailedBuild, Build
      attribute :lastStableBuild, Build
      attribute :lastSuccessfulBuild, Build
      attribute :lastUnstableBuild, Build
      attribute :lastUnsuccessfulBuild, Build
      attribute :nextBuildNumber, Integer

      attribute :property, Hash

      attribute :queueItem, String
      attribute :scm, Hash
      attribute :upstreamProjects, Array
      attribute :url, String
    end

    def url
      URI::encode(@url)
    end

    def building?
      lastBuild.building?
    end

    def passing?
      !disabled? && lastCompletedBuild.success?
    end

    def failing?
      !disabled? && lastCompletedBuild.failure?
    end

    def disabled?
      color == 'disabled'
    end
  end
end
