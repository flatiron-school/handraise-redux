module IssueStats
  def wait_time_total
    (Issue.wait_time_open_in_seconds + Issue.wait_time_closed_in_seconds)/60
  end

  def average_wait_time_total
    Issue.wait_time_total/(Issue.total_open_issues + Issue.total_closed_issues)
  end

  def wait_time_open_in_seconds
    Issue.not_closed.inject(0) do |time, issue|
      time + (Time.now - issue.created_at) 
    end
  end

  def wait_time_closed_in_seconds
    Issue.closed.inject(0) do |time, issue|
      time + (issue.updated_at - issue.created_at) 
    end
  end

  def total_open_issues
    Issue.not_closed.size
  end

  def total_closed_issues
    Issue.closed.size
  end

  def average_wait_time_open
    if total_open_issues == 0
      0
    else
      (Issue.wait_time_open_in_seconds/60)/Issue.total_open_issues
    end
  end

  def average_wait_time_closed
    (Issue.wait_time_closed_in_seconds/60)/Issue.total_closed_issues
  end

end