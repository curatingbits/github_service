require 'octokit'
require 'date'
require_relative 'github_service/client'
module GithubService


  @client = Client.new

  @client.authenticated?




  @client.list_languages(organization: "rails", repo: "rails")

  @client.status_check(organization: "curatingbits", repo: "curatingbits", ref: "1674075fee4f26acae0dbb634370a855333f40ae")




end


