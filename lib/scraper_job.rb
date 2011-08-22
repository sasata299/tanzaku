# -*- coding: utf-8 -*-
class ScraperJob < Struct.new(:my_friends_list, :rest_graph, :profile_url)
  attr_reader :target_user

  def perform
    get_common_user_ids.each do |user_id|
      email = AuthorizedUser.find_by_user_id(user_id).try(:email)
      me = rest_graph.get('me')
      if email
        deliver(email, me, target_user) # 共通の知り合いにメールを送る
      else
        rest_graph.post(
          "#{user_id}/feed", 
          :message => "#{name(me)}さんがあなたの友達の誰かと知り合いになりたがっています。あなたにだけメールでこっそりと教えるのでここから登録をお願いします。", 
          :link => Tanzaku::Application.config.facebook_app_url
        )
        MailQueue.create(
          :common_user_id => user_id,
          :user_id => me["id"],
          :target_user_id => target_user["id"]
        )
      end
    end
  end

  def name(user)
    "#{user['last_name']} #{user['first_name']}"
  end

  def get_common_user_ids
    fetch_target_user_info(my_friends_list)
  end

  def fetch_target_user_info(my_friends_list)
    @friends_list = []

    agent = Mechanize.new
    #agent.user_agent_alias = 'Mac Safari'
    agent.get("http://m.facebook.com/login.php")
    agent.page.form_with(:id => "login_form") {|f|
      f.field_with(:name => "email").value = ENV["EMAIL"]
      f.field_with(:name => "pass").value = ENV["PASS"]
      f.click_button
    }

    scraper(agent)

    (@friends_list & my_friends_list).sample
  end

  def scraper(agent, url=nil)
    target_url = nil
    if url
      target_url = url
    else
      case profile_url
      when /profile\.php\?id=([^&]+)/
        @target_user = rest_graph.get($1)
        target_url = "http://m.facebook.com/friends.php?id=#{@target_user["id"]}"
      when %r!facebook\.com/([^\?]+)!
        @target_user = rest_graph.get($1)
        target_url = "http://m.facebook.com/friends.php?id=#{@target_user["id"]}"
      end
    end
    agent.get(target_url)

    @friends_list += agent.page.search("div.ib a").select{|v| v["href"] !~ /connect\.php/}.map{|a|
      if a["href"] =~ /profile\.php\?id=([^&]+)/
        $1
      else
        name = a["href"].gsub(/\?.+$/, '').gsub(%r!^/!, '')
        User.find_or_from_api(rest_graph, name)
      end
    }

    if (link = agent.page.link_with(:text => "他の友達を見る"))
      link.click
      scraper(agent, agent.page.uri.to_s)
    end
  end
end

