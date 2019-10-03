module GithubService
  module CommitFrequency

    def frequency(commits)
       _temp_arr = commits.map { |commit|
        range(commit['commit']['author']['date'])
      }
      ary =  totals(_temp_arr)
      ary["monthly_average"] = (commits.count / 12).round(2)
      ary
    end

    private

    def range(date)

      instance = date.strftime('%Y-%m-%d')

      d0 = (Date.today-1).strftime('%Y-%m-%d')
      d1 = Date.today.strftime('%Y-%m-%d')
      d2 = (Date.today-7).strftime('%Y-%m-%d')

      if instance.between?(d0, d1)
        "Daily"
      elsif instance.between?(d2,d1)
        "Weekly"
      else
        "More than Weekly"
      end
    end

    def totals(commits)
      commits.inject(Hash.new(0)) { |total, e| total[e] += 1 ; total}
    end
  end
end
