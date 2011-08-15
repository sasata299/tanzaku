module Mailer
  def deliver(user, target_user)
    ses = ActionWebService::SES::Base.new(
      :access_key_id     => acceess_key_id,
      :secret_access_key => secret_access_key
    )
    ses.send_email(
      :subject => "つながり検索からのお知らせです",
      :tet_body => "#{user["name"]}さんが#{target_user["name"]}さんと会いたいようです",
      :source => from_email,
      :to => %W(user["email"])
    )
  end

  private

  def acceess_key_id
    ENV["ACCESS_KEY_ID"]
  end

  def secret_access_key
    ENV["SECRET_ACCESS_KEY"]
  end

  def from_email
    ENV["FROM_EMAIL"]
  end
end
