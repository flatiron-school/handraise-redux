Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '9dd39e1a5bd620295adb', '19ee9be1a67c1f1c1fb841ae0a17d9839d32790e', :client_options => {:ssl => {:verify => false}}
end