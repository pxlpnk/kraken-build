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

  def create_job(job, options = {})
    repo = job.split('.').first
    branch_name = job.split('.').last
    job_config = create_job_configuration(repo, branch_name)
    options.merge!(
      :body => job_config,
      :format => :xml, :headers => { 'content-type' => 'application/xml' })

    self.class.post("/createItem/api/xml?name=#{CGI.escape(job)}", options)
  end

  def create_job_configuration(repo, branch)

    draft = get_job_configuration("#{repo}.master")

    doc = Nokogiri.XML(draft)

    doc.xpath('//branches//hudson.plugins.git.BranchSpec//name').first.content = "#{repo}.#{branch}"

    doc.to_xml
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
