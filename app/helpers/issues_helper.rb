module IssuesHelper

    def show_assign_button?(current_user, issue)
      true if issue.assignee_id.blank? && current_user.can_assign?(issue) && (issue.user != current_user)
    end

    def show_unassign_button?(current_user, issue) 
      true if issue.assignee_id.present? && current_user == issue.assignee && current_user.can_unassign?(issue)
    end

    def show_delete_button?(current_user, issue)
      true if current_user.can_destroy?(issue) && issue.is_unassigned?
    end

    def show_edit_button?(current_user, issue)
      true if current_user.can_edit?(issue) && issue.is_unassigned?
    end

    def show_resolve_button?(current_user, issue)
      true if current_user.can_resolve?(issue)
    end

    def show_more_help_button?(current_user, issue)
      true if issue.is_assigned? && (issue.user == current_user)
    end

    def show_admin_done_button?(current_user, issue)
      true if issue.is_assigned? && (current_user.can_mark_as_helped?(issue))
    end

end
