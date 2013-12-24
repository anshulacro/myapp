OmniAuth.config.logger = Rails.logger
OmniAuth.config.on_failure = AuthenticationsController.action(:omniauth_failure)
Rails.application.config.middleware.use OmniAuth::Builder do
  # The following is for facebook
  provider :facebook,"209286362588042","c554493d293cf42b2712bda4c901daaa" #, {:scope =&gt; 'email, read_stream, read_friendlists, friends_likes, friends_status, offline_access'}

  # If you want to also configure for additional login services, they would be configured here.
end