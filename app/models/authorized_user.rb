class AuthorizedUser < ActiveRecord::Base
  def self.store(user)
    if !find_by_user_id(user["id"])
      create(
        :user_name => "#{user['name']}",
        :user_id => user["id"],
        :email => user["email"]
      )
    end
  end
end
