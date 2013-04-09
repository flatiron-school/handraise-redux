module IssueStats

  def wait_time_total
    (Issue.wait_time_assignable_in_seconds + Issue.wait_time_post_help_in_seconds + Issue.wait_time_closed_in_seconds)/60
  end

  def average_wait_time_total
    Issue.wait_time_total/(Issue.total_assignable_issues
       +
      Issue.total_post_help_issues + Issue.total_closed_issues)
  end


end