require 'spec_helper'

describe SimpleJenkins::Job do

  it "knows when it is passing" do
    job = SimpleJenkins::Job.new(
      color: "red",
      lastCompletedBuild: {result: "SUCCESS"}
    )

    expect(job.passing?).to eq(true)
    expect(job.failing?).to eq(false)
  end

  it "knows when it is failing" do
    job = SimpleJenkins::Job.new(
      color: "red",
      lastCompletedBuild: {result: "FAILURE"}
    )

    expect(job.passing?).to eq(false)
    expect(job.failing?).to eq(true)
  end


  describe "disabled jobs" do
    it "knows when it is disabled" do
      job = SimpleJenkins::Job.new(color: "disabled")
      expect(job.disabled?).to eq(true)
    end

    it "isn't passing or failing when disabled" do
      job = SimpleJenkins::Job.new(color: "disabled", lastCompletedBuild: {result: "FAILURE"})
      expect(job.disabled?).to eq(true)
      expect(job.failing?).to eq(false)
    end

    it "isn't passing or failing when disabled" do
      job = SimpleJenkins::Job.new(color: "disabled", lastCompletedBuild: {result: "SUCCESS"})
      expect(job.disabled?).to eq(true)
      expect(job.passing?).to eq(false)
    end

    it "knows when it is not disabled" do
      job = SimpleJenkins::Job.new(lastCompletedBuild: {result: "SUCCESS"})
      expect(job.disabled?).to eq(false)
    end
  end

  it "knows when it is building" do
    job = SimpleJenkins::Job.new(lastBuild: {building: true})

    expect(job.building?).to eq(true)
  end

  it "knows when it is not building" do
    job = SimpleJenkins::Job.new(lastBuild: {building: false})

    expect(job.building?).to eq(false)
  end

end