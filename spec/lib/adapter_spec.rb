require "spec_helper"
require "uri"

describe SimpleJenkins::Adapter do

  let(:jenkins_url) { "test.com" }
  let(:auth) { "user:pass" }
  let(:adapter) { SimpleJenkins::Adapter.new(auth, jenkins_url) }

  describe "authentication" do
    it "uses authentication" do
      stub_request(:get, /user:pass@test\.com/).to_return(status: 200, body: "{}")
      adapter.fetch_jobs
    end
  end

  describe "#fetch_jobs" do
    it "returns a list of jobs" do
      stub_successful_request
      jobs = adapter.fetch_jobs

      expect(jobs.count).to eq(2)
      expect(jobs.map(&:name)).to match_array(["Brakeman (CPI)", "680Nus"])
    end

    it "fetches build information" do
      stub_successful_request
      jobs = adapter.fetch_jobs

      job = jobs.detect { |job| job.name == "680Nus" }
      build = job.builds.detect { |build| build.number == 10 }

      expect(job.builds.count).to eq(12)
      expect(build.number).to eq(10)
      expect(build.url).to eq("http://squid.hq.nulogy.com/job/680Nus/10/")
    end
  end

  describe "#build" do
    let(:job_name) { "Job Name" }
    let(:job) { SimpleJenkins::Job.new(name: job_name) }

    it "builds without parameters" do
      stub_jenkins_build(job_name, 201, "Message")
      result = adapter.build_job(job)

      expect(result).to have_attributes(
        code: 201,
        success?: true,
        message: "Message"
      )
    end

    it "builds with parameters" do
      stub_jenkins_build(job_name, 201, "Messaging")
      result = adapter.build_job(job, branch: "Something Else")

      expect(result).to have_attributes(
        code: 201,
        success?: true,
        message: "Messaging"
      )
    end

    it "wraps the error case" do
      stub_jenkins_build(job_name, 500, "Error Message")
      result = adapter.build_job(job)

      expect(result).to have_attributes(
        code: 500,
        success?: false,
        message: "Error Message",
      )
    end
  end

  private

  def load_file_fixture(filename)
    File.read("spec/fixtures/#{filename}")
  end

  def stub_successful_request
    stub_request(:get, /test\.com/).to_return(status: 200, body: load_file_fixture("jobs_success.json"))
  end

  def stub_jenkins_build(job_name, status, message = nil)
    stub_request(:post, URI.escape("user:pass@test.com/job/#{job_name}/build")).to_return(status: status, body: message)
    stub_request(:post, URI.escape("user:pass@test.com/job/#{job_name}/buildWithParameters")).to_return(status: status, body: message)
  end
end
