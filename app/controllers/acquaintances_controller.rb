# -*- coding: utf-8 -*-
class AcquaintancesController < ApplicationController
  include Mailer

  def find
    my_friends_list = rest_graph.get('me/friends')["data"].map{|i| i["id"]}

    if request.post? && params[:commit]
      # error handling for deserialize Method and Proc
      rest_graph.lighten!

      Delayed::Job.enqueue(ScraperJob.new(my_friends_list, rest_graph, params[:profile_url]), 0, 1.minute.from_now)

      redirect_to root_path, :notice => true
    end
  end
end
