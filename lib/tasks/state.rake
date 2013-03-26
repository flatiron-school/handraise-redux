namespace :states do
  desc "Rake task to update state of issues"
  task :update => :environment do
    Issue.not_closed.each do |issue|
      case
      when issue.created_at < Time.now-40.minutes 
        issue.status = Issue.status[:instructor_urgent]
        issue.save
      when issue.created_at < Time.now-15.minutes
        issue.status = Issue.status[:instructor_normal]
        issue.save 
      when issue.created_at < Time.now-2.minutes
        issue.status = Issue.status[:fellow_student]
        issue.save
      end       
    end
    puts "#{Time.now} - Updated State of Open Issues!"
  end
end