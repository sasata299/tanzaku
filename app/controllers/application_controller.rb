class ApplicationController < ActionController::Base
  protect_from_forgery

  include RestGraph::RailsUtil

  before_filter :setup

  private

  def facebook_app_url
    "http://apps.facebook.com/tanzaku-staging/"
  end

  def setup
    rest_graph_setup(:auto_authorize => true, :write_cookies => true)

    if params[:code]
      rest_graph.post("me/feed", :message => "つながり短冊を利用し始めました", :link => facebook_app_url)
      AuthorizedUser.store rest_graph.get('me')

      redirect_to facebook_app_url
    end
  end
end
