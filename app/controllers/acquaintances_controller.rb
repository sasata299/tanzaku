# -*- coding: utf-8 -*-
class AcquaintancesController < ApplicationController
  include Mailer

  def find
    my_friends_list = rest_graph.get('me/friends')["data"].map{|i| i["id"]}

    if request.post? && params[:commit]
      # error handling for deserialize Method and Proc
      rest_graph.lighten!

      sj = ScraperJob.new(my_friends_list, rest_graph, params[:profile_url])
      sj.get_common_user_ids.each do |user_id|
        user = AuthorizedUser.find_by_user_id(user_id)
        me = rest_graph.get('me')
        if user
          deliver(user.email, me, sj.target_user)
        else
          rest_graph.post(
            "#{user_id}/feed", 
            :message => "#{me["last_name"]} #{me["first_name"]}さんがあなたの友達の誰かと知り合いになりたがっています。あなたにだけメールでこっそりと教えるのでここから登録をお願いします。", 
            :link => facebook_app_url
          )
          MailQueue.create(
            :common_user_id => user_id,
            :user_id => me["id"],
            :target_user_id => sj.target_user["id"]
          )
        end
      end

      #Delayed::Job.enqueue(ScraperJob.new(my_friends_list, rest_graph, params[:profile_url]), 0, 1.minute.from_now)
      redirect_to root_path, :notice => true
    end
  end
end
