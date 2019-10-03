require_relative 'commit_frequency'
module GithubService
  class Client
    include CommitFrequency
    attr_accessor :client

    def initialize
      Octokit.configure do |c|
        c.api_endpoint = ENV['GITHUB_ENDPOINT_URL'] || "https://api.github.com/"
      end
      @client = Octokit::Client.new(:access_token => ENV["GITHUB_ACCESS_TOKEN"], per_page: 100)
    end


    def authenticated?
      @client.user_authenticated?
    end

    def branches
      @client.branches
    rescue Octokit::NotFound, Octokit::InvalidRepository
      "Repo not found or invalid"
    end

    def commits(organization:, repo:, branch:)
      @client.commits("#{organization}/#{repo}", branch)
    rescue Octokit::NotFound, Octokit::InvalidRepository
      "Repo not found or invalid"
    end

    def commits_frequency(organization:, repo:, branch:)
      frequency(@client.commits("#{organization}/#{repo}", branch))
    rescue Octokit::NotFound, Octokit::InvalidRepository
      "Repo not found or invalid"
    end

    def commits_range(organization:, repo:, startDate:, endDate:, branch:)
      frequency(@client.commits_between("#{organization}/#{repo}", startDate, endDate, branch))
    rescue Octokit::NotFound, Octokit::InvalidRepository
      "Repo not found or invalid"
    end

    def commits_status(organization:, repo:, sha:)
      @client.statuses("#{organization}/#{repo}", sha)
    end

    def repo_events(organization:, repo:)
      @client.repository_events("#{organization}/#{repo}")
    rescue Octokit::NotFound, Octokit::InvalidRepository
      "Repo not found or invalid"
    end

    def pull_requests(organization:, repo:, status: "open")
      @client.pull_requests("#{organization}/#{repo}", :state => status)
    rescue Octokit::NotFound, Octokit::InvalidRepository
      "Repo not found or invalid"
    end

    def status_check(organization:, repo:, ref:)
      @client.status("#{organization}/#{repo}", ref)
    rescue Octokit::NotFound, Octokit::InvalidRepository
      "Repo not found or invalid"
    end

    def list_languages(organization:,repo:)
      h = @client.languages("#{organization}/#{repo}")
      language_average(h)
    end

    def branch_protection(organization:, repo:, branch: "master")
      @client.branch_protection("#{organization}/#{repo}", branch)
    rescue Octokit::NotFound, Octokit::InvalidRepository
      "Repo not found or invalid"
    end

    def language_average(h)
      sum = h.inject(0) { |sum, lang| sum += lang[1] }
     p  h.each_with_object({}) { |(k, v), hash| hash[k] = "#{(v * 100.0 / sum).round(2)}%" }

    end

  end
end
