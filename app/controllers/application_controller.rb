class ApplicationController < ActionController::Base
  protect_from_forgery

  include RestGraph::RailsUtil

  before_filter :setup

  private

  def setup
    rest_graph_setup(:auto_authorize => true, :write_cookies => true)

    if params[:code]
      #rest_graph.post("me/feed", :message => "つながり短冊を利用し始めました", :link => Tanzaku::Application.config.facebook_app_url)

      user = rest_graph.get('me')
      AuthorizedUser.store(user)

      if queue = MailQueue.first(:conditions => ["common_user_id = ?", user["id"]])
        deliver(user["email"], rest_graph.get(queue.user_id), rest_graph.get(queue.target_user_id))
        queue.destroy
      end

      redirect_to Tanzaku::Application.config.facebook_app_url
    end
  end
end
