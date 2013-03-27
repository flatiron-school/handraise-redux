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
    assigned_user = User.find_by_id(issue.assignee_id).name

    case type
    when 'assign'
      "Hi #{issue.user.name}, your issue (#{issue.title}) is now assigned to #{assigned_user}."
    when 'unassign'
      "Hi #{issue.user.name}, #{assigned_user} unassigned from your issue '#{issue.title}'"
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

end