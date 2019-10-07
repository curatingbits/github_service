require 'octokit'
require 'date'
require_relative 'github_service/client'
module GithubService


  @client = Client.new

  @client.authenticated?

  @client.list_languages(organization: "rails", repo: "rails")

  @client.status_check(organization: "jekyll", repo: "jekyll", sha: "master")

  @client.commits_status(organization: "rails", repo: "rails", sha: "165753163c17b36f0ff45b43a80d8deb9e16f075")


end


