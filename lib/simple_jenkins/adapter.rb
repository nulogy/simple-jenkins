module SimpleJenkins
  class Adapter
    def initialize(auth, jenkins_url)
      @auth = auth
      @jenkins_url = jenkins_url
    end

    def build_job(job, params = {})
      if params.empty?
        path = URI::encode("#{@jenkins_url}/job/#{job.name}/build")
      else
        path = URI::encode("#{@jenkins_url}/job/#{job.name}/buildWithParameters")
      end

      result = RestClient.post(path, params, headers)

      return Response.new(
        code: result.code,
        message: result
      )

    rescue RestClient::Exception => e
      return Response.new(
        code: e.response.code,
        message: e.response
      )
    end

    def fetch_jobs
      attrs = extract_attrs(Job)

      path = "#{@jenkins_url}/api/json?tree=jobs[#{attrs.join(",")}]"
      api_response = RestClient.get(path, headers)

      jobs_hash = JSON.parse(api_response.body).fetch("jobs", {})

      return jobs_hash.map { |job_hash| Job.new(job_hash) }

    rescue RestClient::Exception => e
      raise ApiException, e.response
    end

    private

    def headers
      return {} unless @auth

      {
        "Authorization" => "Basic #{Base64.encode64(@auth).chomp}"
      }
    end

    def extract_attrs(model)
      model.attribute_set
        .map { |attr| get_attr_name(attr) }
    end

    def get_attr_name(attr)
      if attr.is_a?(Virtus::Attribute::Collection) && attr.type.member_type != Axiom::Types::Object
        "#{attr.name}[#{extract_attrs(attr.type.member_type).join(",")}]"
      else
        attr.name
      end
    end
  end

  class ApiException < RuntimeError;
  end
end