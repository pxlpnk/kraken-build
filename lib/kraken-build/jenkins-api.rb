class JenkinsApi
  include HTTParty

  attr_accessor :skip_plugins

  def initialize(options = {})
    if options[:port]
      self.class.base_uri "#{options[:host]}:#{options[:port]}"
    else
      self.class.base_uri  options[:host]
    end

    if (options[:username] && options[:password])
      self.class.basic_auth options[:username] , options[:password]
    end
    if (options[:skip_plugins])
      self.skip_plugins = options[:skip_plugins]
    else
      self.skip_plugins = []
    end
  end

  def get_jobs(options = {})
    response = self.class.get("/api/json/", options)
    jobs = response["jobs"]

    jobs.map { |job| job["name"] }
  end

  def create_job(job, options = {})
    repo, branch_name = job.split('.', 2)
    job_config = create_job_configuration(repo, branch_name)
    options.merge!(
      :body => job_config,
      :format => :xml, :headers => { 'content-type' => 'application/xml' })

    self.class.post("/createItem/api/xml?name=#{CGI.escape(job)}", options)
  end

  def create_job_configuration(repo, branch)
    draft = get_job_configuration("#{repo}.master")
    doc = REXML::Document.new(draft)
    REXML::XPath.first(doc, '//branches//hudson.plugins.git.BranchSpec//name').text = branch

    plugin_names = self.skip_plugins.map { |n| "hudson.plugins.#{n}" }
    publishers = REXML::XPath.first(doc, '//project/publishers')
    if publishers && publishers.has_elements? && self.skip_plugins && !(self.skip_plugins.empty?)
      publishers.children.select { |child| child.xpath.match %r[/hudson\.plugins] }.each do |plugin|
        doc.delete_element(plugin.xpath) if plugin_names.any? { |name| plugin.xpath[name]}
      end
    end

    doc.to_s
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
