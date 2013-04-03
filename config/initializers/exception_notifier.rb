Rails.application.config.middleware.use ExceptionNotifier,
  :email_prefix => "Handrai.se Error: ",
  :sender_address => %{"notifier" <postmaster@handraise.mailgun.org>},
  :exception_recipients => %w{ei-lene.heng@flatironschool.com}
