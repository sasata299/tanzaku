# -*- coding: utf-8 -*-
module Mailer
  def deliver(to_email, user, target_user)
    ses = AWS::SES::Base.new(
      :access_key_id     => Tanzaku::Application.config.acceess_key_id,
      :secret_access_key => Tanzaku::Application.config.secret_access_key
    )
    ses.send_email(
      :subject => "つながり短冊からのお知らせです",
      :text_body => body(user, target_user),
      :source => from_email,
      :to => to_email
    )
  end

  private

  def from_email
    %Q!"#{encode("つながり短冊")}" <#{Tanzaku::Application.config.from_email}>!
  end

  def body(user, target_user)
    "#{user["last_name"]} #{user["first_name"]}さんが#{target_user["last_name"]} #{target_user["first_name"]}さんと会いたいようです。"
  end

  def encode(subject)
    NKF.nkf('-j -W --cp932', subject)
  end
end
