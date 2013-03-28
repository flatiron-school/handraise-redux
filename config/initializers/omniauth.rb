Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'], :client_options => {:ssl => {:verify => false}}, :scope => 'user,repo,gist'
end