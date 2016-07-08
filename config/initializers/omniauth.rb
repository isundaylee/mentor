OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    Rails.env.production? ? ENV['GOOGLE_CLIENT_ID'] : '225692327577-jprscpiv76ug1u04ske2fpi4d7scq5ne.apps.googleusercontent.com',
    Rails.env.production? ? ENV['GOOGLE_CLIENT_SECRET'] : 'B9n7-Sb5RCLTJMVifbVAZJdm',
    {
      client_options:
      {
        ssl:
        {
          ca_file: Rails.root.join("cacert.pem").to_s
        }
      }
    }
end