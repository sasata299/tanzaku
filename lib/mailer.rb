module Mailer
  def deliver(to_email, user, target_user)
    ses = AWS::SES::Base.new(
      :access_key_id     => Tanzaku::Application.config.acceess_key_id,
      :secret_access_key => Tanzaku::Application.config.secret_access_key
    )
    ses.send_email(
      :subject => "#{name(user)}さんの願い事をお届けします！",
      :text_body => body(user, target_user),
      :source => from_email,
      :to => to_email
    )
  end

  private

  def from_email
    %Q!"#{encode('つながり短冊')}" <#{Tanzaku::Application.config.from_email}>!
  end

  def body(user, target_user)
    <<-EOF
    こんにちは。つながり短冊からのお知らせです。
    #{name(user)}さん (#{user['link']}) がつながり短冊に願い事をしました。

    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    　#{name(target_user)}さんに会いたい
    　#{target_user['link']}
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

    あなたは#{name(user)}さんと#{name(target_user)}さん、どちらも知っていますよね。
    同じイベント/同じ場所にいる際にはぜひ紹介してあげましょう。

    あなたの協力で、2人はオンラインのつながりからオフラインのつながりに :-)

    ---
    つながり短冊
    #{root_url}
    EOF
  end

  def encode(subject)
    NKF.nkf('-j -W --cp932', subject)
  end

  def name(obj)
    "#{obj['last_name']} #{obj['first_name']}"
  end
end
