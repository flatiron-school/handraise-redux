namespace :stats do
  # Loop over all issue stats and calculate wait time
  desc "Calculate issue stats"
  task :calculate => :environment do
    IssueStat.all.each do |issue|
      issue.calculate_issue_stat
    end
  end
end