Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV[''], ENV['']
end