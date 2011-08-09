class ApplicationController < ActionController::Base
  protect_from_forgery

  include RestGraph::RailsUtil

  before_filter :setup
  helper_method :current_user

  private

  def setup
    rest_graph_setup(:auto_authorize => true, :write_cookies => true)

    if params[:code]
      redirect_to "http://apps.facebook.com/tanzaku-staging"
    end
  end
end
