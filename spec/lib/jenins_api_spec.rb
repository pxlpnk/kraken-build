require 'spec_helper'

describe JenkinsApi do

  context "configurations" do
    before(:each) do
      @api = nil
    end

    it "uses basic_auth when username and password prived" do
      options = {:username => 'user', :password => 'password'}
      @api = JenkinsApi.new(options)

      options[:username].should == @api.class.default_options[:basic_auth][:username]
      options[:password].should == @api.class.default_options[:basic_auth][:password]
    end

    it "uses no basic_auth when username and password are not prived" do
      pending("Flapping spec")
      options = {}
      @api = JenkinsApi.new(options)

      options[:username].should_not == @api.class.default_options[:basic_auth][:username]
      options[:password].should_not == @api.class.default_options[:basic_auth][:password]
    end

    it "uses a port when provided" do
      options = {:host => "host", :port => '1337'}
      @api = JenkinsApi.new(options)

      @api.class.default_options[:base_uri].should == 'http://host:1337'
    end

  end


  context "retriving data from jenkins" do
    before(:each) do
      @api = JenkinsApi.new
    end

    it "returns active jobs from jenkins" do
      j = []
      j << {"name" => "Foo"}
      j << {"name" => "Bar"}

      results = {"jobs" => j}

      @api.class.should_receive(:get).and_return(results)
      jobs = @api.get_jobs

      jobs.should include "Foo"
      jobs.should include "Bar"

    end

    it "removes a job" do
      @api.class.should_receive(:post).with("/job/FooJob/doDelete").and_return(true)
      @api.remove_job("FooJob")
    end

    it "triggers a build for a job" do
      @api.class.should_receive(:get).with("/job/FooJob/build").and_return(true)
      @api.build_job("FooJob")
    end

    it "returns the xml configuration for a job" do
      a = <<XML
<xml>foo</xml>
XML
      xml = double()
      xml.should_receive(:body).and_return(a)

      @api.class.should_receive(:get).with("/job/FooJob/config.xml", {}).and_return(xml)
      @api.get_job_configuration("FooJob").should be(a)
    end

  end


  context "create a job" do
    before(:each) do
      @api = JenkinsApi.new
    end

    it "creates a new job with a given xml configuration" do
      a = <<XML
<xml>foo</xml>
XML
      @api.class.should_receive(:post).with("/createItem/api/xml?name=FooJob", {
                                              :body => a,
                                              :format => :xml,
                                              :headers => {"content-type"=>"application/xml" }})

      @api.create_job("FooJob",a)

    end
  end

end
