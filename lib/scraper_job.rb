class ScraperJob < Struct.new(:my_friends_list, :rest_graph, :profile_url, :root_url)
  include Mailer

  attr_reader :target_user

  def perform
    common_user_id = get_common_user_id(my_friends_list)
    exit if common_user_id.blank?

    me = rest_graph.get('me')
    if email = AuthorizedUser.find_by_user_id(common_user_id).try(:email)
      deliver(email, me, target_user) # 共通の知り合いにメールを送る
    else
      rest_graph.post(
        "#{common_user_id}/feed", 
        :message => "#{me['name']}さんがあなたの友達の誰かと会いたいようです。メールであなたにだけ教えるのでここからアプリの許可をお願いします。", 
        :link => root_url
      )
      MailQueue.create(
        :common_user_id => common_user_id,
        :user_id => me["id"],
        :target_user_id => target_user["id"]
      )
    end
  end

  def get_common_user_id(my_friends_list)
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

    (@friends_list.compact & my_friends_list).sample
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

