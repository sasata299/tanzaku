# -*- coding: utf-8 -*-

class AcquaintancesController < ApplicationController
  def find
    my_friends_list = rest_graph.get('me/friends')["data"].map{|i| i["id"]}

    if request.post?
      #rest_graph.post('me/feed', :message => "test_#{rand(10000)}")
      fetch_target_user_info
      @common_ids = @friends_list & my_friends_list

      # TODO: send message
    end
  end

  private

  def fetch_target_user_info
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
  end

  def scraper(agent, url=nil)
    target_url = nil
    if url
      target_url = url
    else
      if params[:profile_url] =~ /profile\.php\?id=([^&]+)/
        target_url = "http://m.facebook.com/friends.php?id=#{$1}"
      elsif params[:profile_url] =~ %r!facebook\.com/([^\?]+)!
        target_url = "http://m.facebook.com/friends.php?id=#{rest_graph.get($1)["id"]}"
      end
    end
    agent.get(target_url)

    @friends_list += agent.page.search("div.ib a").select{|v| v["href"] !~ /connect\.php/}.map{|a| 
      if a["href"] =~ /profile\.php\?id=([^&]+)/
        $1
      else
        name = a["href"].gsub(/\?.+$/, '').gsub(%r(^/), '')
        User.find_or_from_api(rest_graph, name)
      end
    }

    if (link = agent.page.link_with(:text => "他の友達を見る"))
      link.click
      logger.debug agent.page.uri.to_s
      scraper(agent, agent.page.uri.to_s)
    end
  end
end
