class ApplicationController < ActionController::Base
  protect_from_forgery

  include RestGraph::RailsUtil
  include Mailer

  before_filter :setup

  private

  def setup
    rest_graph_setup(:auto_authorize => true, :write_cookies => true)

    if params[:code]
      user = rest_graph.get('me')
      AuthorizedUser.store(user)

      if queue = MailQueue.first(:conditions => ["common_user_id = ?", user["id"]])
        deliver(user["email"], rest_graph.get(queue.user_id), rest_graph.get(queue.target_user_id))
        queue.destroy
      end

      cookies['auth'] = {:value => '1', :expires => Time.parse('2030-01-01 00:00:00')}

      redirect_to Tanzaku::Application.config.facebook_app_url
    end
  end
end
