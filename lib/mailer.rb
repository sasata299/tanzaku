module Mailer
  def deliver(to_email, user, target_user)
    ses = AWS::SES::Base.new(
      :access_key_id     => acceess_key_id,
      :secret_access_key => secret_access_key
    )
    ses.send_email(
      :subject => "つながり検索からのお知らせです",
      :text_body => body(user, target_user),
      :source => from_email,
      :to => to_email
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

  def body(user, target_user)
    "#{user["last_name"]} #{user["first_name"]}さんが#{target_user["last_name"]} #{target_user["first_name"]}さんと会いたいようです。"
  end
end
