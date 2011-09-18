class AcquaintancesController < ApplicationController
  def auth
    rest_graph.get('me/friends') # for authentication
    render :action => "find"
  end

  def find
    if request.post? && params[:commit]
      my_friends_list = rest_graph.get('me/friends')["data"].map{|i| i["id"]}

      rest_graph.lighten! # error handling for deserialize Method and Proc
      Delayed::Job.enqueue(ScraperJob.new(my_friends_list, rest_graph, params[:profile_url], root_url), 0, 1.minute.from_now)

      case params[:profile_url]
        when /profile\.php\?id=([^&]+)/
        flash[:target_user_image] = rest_graph.get($1, :fields => 'picture')["picture"]
      when %r!facebook\.com/([^\?]+)!
        flash[:target_user_image] = rest_graph.get($1, :fields => 'picture')["picture"]
      end

      redirect_to find_path, :notice => true
    end
  end
end
