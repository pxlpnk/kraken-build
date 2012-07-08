require 'spec_helper'

describe GithubApi do

  before(:each)  do
    @options = {:token => '1234',
      :owner => "FooBert",
      :repository => "uber-repo"
    }

    @api = GithubApi.new(@options)
  end

  it "returns the branches of a Github repository" do
    response = []
    response << {:name => "foo"}
    response << {:name => "bar"}
    @api.class.should_receive(:get).with("/repos/#{@options[:owner]}/#{@options[:repository]}/branches?access_token=#{@options[:token]}",{}).and_return(response)

    @api.get_branches
  end

end
