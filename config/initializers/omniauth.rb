Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '738025532990730', '762efe7881a1f0690d7a1ccb1d91c78b', 
    {
    scope: 'email,public_profile,user_location,user_birthday,user_about_me',
    info_fields: 'name,email'
  }
end