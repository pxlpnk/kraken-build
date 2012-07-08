require "HTTParty"
require "awesome_print"

require "kraken-build/version"
require "kraken-build/jenkins-api.rb"
require "kraken-build/github-api.rb"



module KrakenBuild

  def self.set_config(options = {})
    @config = options
    @repository = options[:repository]
    @github = GithubApi.new(@config)
    @jenkins = JenkinsApi.new(@config)
    @jobs = []
    @branches = []

    @config
  end

  def self.get_jenkins_branches
    @jenkins.get_jobs.map{ |job| job =~ /^#{@repository}\.(.*)$/ && $1 }.compact
  end

  def self.get_github_branches
    @github.get_branches
  end

  def self.run
    @jobs = get_jenkins_branches
    @branches = get_github_branches

    create = compute_jobs_to_create
      create.map do |job|
        job_name = "#{@repository}.#{job}"
        puts "creating => #{job_name}"
    #     @jenkins.create_job(job_name,"")
    #     @jenkins.build_job(job_name)
      end


    remove = compute_jobs_to_remove
    remove.map do |job|
      job_name = "#{@repository}.#{job}"
      puts "removing => #{job_name}"
      @jenkins.remove_job(job_name)
    end

  end

   def self.compute_jobs_to_create
    @branches - @jobs
  end

  def self.compute_jobs_to_remove
    @jobs - @branches
  end

end
