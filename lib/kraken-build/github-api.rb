class GithubApi
  include HTTParty

  def initialize(config)
    @oauth_token = config[:token]
    @owner = config[:owner]
    @repository = config[:repository]
    @headers = {:headers => {"User-Agent" => "Kraken-Build"}}
    self.class.base_uri "https://api.github.com"
  end

  def get_branches(options = {})
    options.merge!(@headers)
    response = self.class.get("/repos/#{@owner}/#{@repository}/branches?access_token=#{@oauth_token}", options)
    response.map{|branch| branch["name"]}
  end
end
