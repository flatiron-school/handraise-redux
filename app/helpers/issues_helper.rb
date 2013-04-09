module IssuesHelper
  <ul class="assignment_buttons">
    <li><%= link_to(raw('<button class="btn btn-success">I\'ll Help</button>'), assign_path(issue), :class => "assign_hide") if 

    def is_assigned?(issue)
      true if issue.assignee_id.blank?
    end

    @current_user.can_assign?(issue) && (issue.user != @current_user)    
    <li><%= link_to(raw('<button class="btn btn-danger">Unassign</button>'), unassign_path(issue), :class => "assign_hide") if issue.assignee_id.present? && @current_user == issue.assignee && @current_user.can_unassign?(issue) %></li>
  </ul>
  <ul class="issue_icons">
    <li><%= link_to(raw('<i class="icon-remove btn btn-danger"></i>'), issue, method: :delete, data: { confirm: 'Are you sure?' }) if current_user.can_destroy?(issue) && issue.is_unassigned? %>
    </li>
    <li><%= link_to(raw('<i class="icon-pencil btn btn-warning"></i>'), edit_issue_path(issue)) if @current_user.can_edit?(issue) && issue.is_unassigned? %></li>
    <li><%= link_to(raw('<i class="icon-ok btn btn-success"></i>'), resolve_path(issue)) if @current_user.can_resolve?(issue) %></li>
    <li><%= link_to(raw('<button class="btn btn-danger">Need more help</button>'), unassign_path(issue)) if issue.is_assigned? && (issue.user == current_user) %>
    </li>
    <li><%= link_to(raw('<button class="btn btn-success">Done</button>'), helped_path(issue)) if issue.is_assigned? && (current_user.can_mark_as_helped?(issue)) %>
    </li>
  </ul>
end
