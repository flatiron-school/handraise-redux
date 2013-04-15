 class TwilioWrapper

  def initialize
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    @from = ENV['TWILIO_FROM']
  end

  def client
    @client
  end

  def from
    @from
  end

  def craft_message(issue, type)
    if issue.class == Issue
      if issue.assignee_id
        assigned_user = User.find_by_id(issue.assignee_id).name
      end
    end

    case type
    when 'assign'
      "Hi #{issue.user.name}, your issue (#{issue.title}) is now assigned to #{assigned_user}."
    when 'unassign'
      "Hi #{issue.user.name}, #{assigned_user} unassigned from your issue '#{issue.title}'"
    when 'response'
      "Hi #{issue.user.name}, a response has been posted to your issue '#{issue.title}'"    
    when 'answer'
      "Hi #{issue.user.name}, your response has been marked as the answer for '#{issue.issue.title}'"      
    when 'unanswer'
      "Hi #{issue.user.name}, your response has been removed as the answer for '#{issue.issue.title}'" 
    when 'new_issues'
      "Hi, there is now an issue in the issue queue."    
    when 'upvote issue'
      "Hi, the class has voted an issue to urgent status."
    end
  end

  def create_sms(issue, type)
    message = craft_message(issue, type)

    client.account.sms.messages.create(
      :from => from,
      :to => issue.user.cell,
      :body => message
    )
  end

  def admin_sms(user, type)
    message = craft_message(user, type)

    client.account.sms.messages.create(
      :from => from,
      :to => user.cell,
      :body => message
    )
  end

end