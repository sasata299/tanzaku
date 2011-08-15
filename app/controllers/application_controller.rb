class ApplicationController < ActionController::Base
  protect_from_forgery

  include RestGraph::RailsUtil

  before_filter :setup

  private

  def setup
    rest_graph_setup(:auto_authorize => true, :write_cookies => true)

    if params[:code]
      top_url = "http://apps.facebook.com/tanzaku-staging/"
      rest_graph.post("me/feed", :message => "つながり短冊を利用し始めました", :link => top_url)
      redirect_to top_url
    end
  end
end
