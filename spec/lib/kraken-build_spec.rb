require 'spec_helper'

describe KrakenBuild do
  context "Setting config" do
    let(:options) { mock(Hash).as_null_object }

    it "sets the config options at @config" do
      kraken = KrakenBuild.set_config(options)
      KrakenBuild.instance_variable_get(:@config).should eq(options)
    end

    it "sets the repository option as @repository" do
      repository = mock(String)
      options.should_receive(:[]).with(:repository).and_return(repository)
      kraken = KrakenBuild.set_config(options)
      KrakenBuild.instance_variable_get(:@repository).should eq(repository)
    end

    it "sets the github api from instance call" do
      github_api = mock(GithubApi).as_null_object
      GithubApi.should_receive(:new).and_return(github_api)
      kraken = KrakenBuild.set_config(options)
      KrakenBuild.instance_variable_get(:@github).should eq(github_api)
    end
    it "sets the jenkins api from instance call" do
      jenkins_api = mock(GithubApi).as_null_object
      JenkinsApi.should_receive(:new).and_return(jenkins_api)
      kraken = KrakenBuild.set_config(options)
      KrakenBuild.instance_variable_get(:@jenkins).should eq(jenkins_api)
    end
    it "returns the config" do
      kraken = KrakenBuild.set_config(options)
      KrakenBuild.instance_variable_get(:@config).should eq(options)
      kraken.should eq(options)
    end

  end
end
