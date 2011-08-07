# -*- coding: utf-8 -*-
class AcquaintancesController < ApplicationController
  def find
    my_friends_list = rest_graph.get('me/friends')["data"].map{|i| i["id"]}

    if request.post?
      # error handling for deserialize Method and Proc
      rest_graph.log_method = nil
      rest_graph.error_handler = 'dummy'

      Delayed::Job.enqueue(ScraperJob.new(my_friends_list, rest_graph, params[:profile_url]), 0, 1.minute.from_now)

      redirect_to root_path, :notice => "処理を受け付けました"
    end
  end
end
