require "HTTParty"
require "awesome_print"
require 'xmlsimple'


class JenkinsApi
  include HTTParty


  def initialize(options = {})

    if options[:port]
      self.class.base_uri "#{options[:host]}:#{options[:port]}"
    else
      self.class.base_uri  options[:host]
    end

    if(options[:username] && options[:password])
      self.class.basic_auth options[:username] , options[:password]
    end

  end

  def get_jobs(options = {})
    response = self.class.get("/api/json/", options)

    jobs = response["jobs"]

    jobs.map{|job| job["name"]}
  end

  def create_job(job_name, job_config, options = {})
    options.merge!(
      :body => job_config,
      :format => :xml, :headers => { 'content-type' => 'application/xml' })

    self.class.post("/createItem/api/xml?name=#{CGI.escape(job_name)}", options)
  end

  def get_job_configuration(job, options = {})
    response = self.class.get("/job/#{job}/config.xml", options)

    response.body
  end

  def remove_job(job_name, options={})
    self.class.post("/job/#{CGI.escape(job_name)}/doDelete")
  end

  def build_job(job_name, options={})
    self.class.get("/job/#{CGI.escape(job_name)}/build")
  end

end
