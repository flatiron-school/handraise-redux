namespace :states do
  desc "Rake task to update state of issues"
  task :update => :environment do
    Issue.not_closed.each do |issue|
      case
      when issue.created_at < Time.now-40.minutes 
        issue.to_instructor_urgent
        issue.save
      when issue.created_at < Time.now-15.minutes
        issue.to_instructor_normal
        issue.save 
      when issue.created_at < Time.now-2.minutes
        issue.to_fellow_student
        issue.save
      end       
    end
    puts "#{Time.now} - Updated State of Open Issues!"
  end

  desc "Rake task to auto-assign first unassigned task in instructor queue to open instructor"
  task :auto_assign => :environment do
    
    # Loop over all issues in instructor (urgent and normal) queue that are unassigned - loop order by number in queue
    # Assign first issue in that list to first instructor
    # Repeat for other available instructors

    User.admin.each do |admin|
      next unless admin.is_available?
      issue = Issue.for_instructor
      issue.assignee = admin
      issue.save
      redirect_to assigned_path

      puts "Assigned Issue '#{issue.title}', to #{admin.name}"
    end

    puts "#{Time.now} - Auto assigned issues to available instructors!"
  end

end