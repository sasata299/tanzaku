module EnvDefaults
  def default_app_id
    ENV["FACEBOOK_APP_ID"]
  end

  def default_secret
    ENV["FACEBOOK_APP_SECRET"]
  end

  def default_auto_authorize_scope
    "publish_stream,email"
  end
end

RestGraph.send(:extend, EnvDefaults)
