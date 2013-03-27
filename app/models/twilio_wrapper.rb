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
    case type
    when 'assign'
      "#{issue.user.name}, your issue is now assigned to #{User.find_by_id(issue.assignee_id).name}."
    when 'unassign'
      "#{User.find_by_id(issue.assignee_id).name} unassigned him/herself from your question '#{issue.title}'"
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