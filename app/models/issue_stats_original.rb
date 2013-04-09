module IssueStats
  attr_accessor 
  def wait_time_total
    (Issue.wait_time_assignable_in_seconds + Issue.wait_time_closed_in_seconds)/60
  end

  def average_wait_time_total
    Issue.wait_time_total/(Issue.total_assignable_issues + Issue.total_closed_issues)
  end

  # Open /assignable issues stats
  def wait_time_assignable_in_seconds
    Issue.assignable.inject(0) do |time, issue|
      time + (Time.now - issue.created_at) 
    end
  end

  def total_assignable_issues
    Issue.assignable.size
  end

  def average_wait_time_assignable
    if total_assignable_issues == 0
      0
    else
      (Issue.wait_time_assignable_in_seconds/60)/Issue.total_assignable_issues
    end
  end


  # Post_help issues stats
  def wait_time_post_help_in_seconds
    Issue.post_help.inject(0) do |time, issue|
      time + (Time.now - issue.created_at) 
    end
  end

  def total_post_help_issues
    Issue.post_help.size
  end

  def average_wait_time_post_help
    if total_post_help_issues == 0
      0
    else
      (Issue.wait_time_post_help_in_seconds/60)/Issue.total_post_help_issues
    end
  end

  # Closed issues stats
  def wait_time_closed_in_seconds
    Issue.closed.inject(0) do |time, issue|
      time + (issue.updated_at - issue.created_at) 
    end
  end

  def total_closed_issues
    Issue.closed.size
  end

  def average_wait_time_closed
    (Issue.wait_time_closed_in_seconds/60)/Issue.total_closed_issues
  end

  def reset_issue_stats
    # Issue.wait_time_total=0
    # Issue.average_wait_time_total=0
    # Issue.wait_time_assignable_in_seconds=0
    # Issue.total_assignable_issues=0
    # Issue.average_wait_time_assignable=0
    # Issue.wait_time_post_help_in_seconds=0
    # Issue.total_post_help_issues=0
    # Issue.average_wait_time_post_help=0
    # Issue.wait_time_closed_in_seconds=0
    # Issue.total_closed_issues=0
    # Issue.average_wait_time_closed=0
  end

end
