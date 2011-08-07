class User < ActiveRecord::Base
  def self.find_or_from_api(rest_graph, name)
    if user = User.find_by_user_name(name)
      user.user_id
    else
      user_id = rest_graph.get(name)["id"]
      User.create(:user_name => name, :user_id => user_id) if user_id

      user_id
    end
  end
end
