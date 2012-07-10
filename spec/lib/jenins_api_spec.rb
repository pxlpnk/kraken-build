require 'spec_helper'

describe JenkinsApi do

  context "configurations" do
    before(:each) do
      api = JenkinsApi.new
    end

     it "uses no basic_auth when username and password are not prived" do
      pending("flapping")
      asd = {:user_name => nil, :password =>"nil"}
      api = asd
      api = JenkinsApi.new(asd)

      api.class.default_options[:basic_auth].should be(nil)
    end

    it "uses basic_auth when username and password prived" do
      options = {:username => 'user', :password => 'password'}
      api = JenkinsApi.new(options)

       api.class.default_options[:basic_auth][:username] == options[:username].should
       api.class.default_options[:basic_auth][:password] == options[:password].should
    end

    it "uses a port when provided" do
      options = {:host => "host", :port => '1337'}
      api = JenkinsApi.new(options)

      api.class.default_options[:base_uri].should == 'http://host:1337'
    end

  end


  context "when interacting with Jenkins" do
    before(:each) do
      @api = JenkinsApi.new
    end

    it "#get_jobs returns an array of jobs" do
      j = []
      j << {"name" => "Foo"}
      j << {"name" => "Bar"}

      results = {"jobs" => j}

      @api.class.should_receive(:get).and_return(results)

      jobs = @api.get_jobs

      jobs.should include "Foo"
      jobs.should include "Bar"
    end

    it "#remove_job returns true if a job was deleted successfully" do
      job_name = "foo.test_branch"

      @api.class.should_receive(:post).with("/job/#{CGI.escape(job_name)}/doDelete").and_return(true)

      @api.remove_job(job_name)
    end

    it "#build_job returns true and triggers a build for a job" do
      @api.class.should_receive(:get).with("/job/FooJob/build").and_return(true)

      @api.build_job("FooJob")
    end

    it "#get_job_configuration returns the xml configuration for a job" do
      a = <<XML
<xml>foo</xml>
XML
      xml = double()
      xml.should_receive(:body).and_return(a)

      @api.class.should_receive(:get).with("/job/FooJob/config.xml", {}).and_return(xml)

      @api.get_job_configuration("FooJob").should be(a)
    end

  end


  context "#create_job returns true on the create a job" do
    before(:each) do
      @api = JenkinsApi.new
    end

    it "creates a new job with a given xml configuration" do


      a = <<XML
<xml>foo</xml>
XML

      repo = "FooRepo"
      branch = "master"
      job = "#{repo}.#{branch}"

      job = "FooRepo.master"

      @api.should_receive(:create_job_configuration).with(repo, branch).and_return(a)

      @api.class.should_receive(:post).with("/createItem/api/xml?name=#{job}", {
                                              :body => a,
                                              :format => :xml,
                                              :headers => {"content-type"=>"application/xml" }})

      @api.create_job("FooRepo.master")
    end
  end

end
