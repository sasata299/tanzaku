require "spec_helper"

describe FriendsController do
  describe "routing" do

    it "routes to #index" do
      get("/friends").should route_to("friends#index")
    end

    it "routes to #new" do
      get("/friends/new").should route_to("friends#new")
    end

    it "routes to #show" do
      get("/friends/1").should route_to("friends#show", :id => "1")
    end

    it "routes to #edit" do
      get("/friends/1/edit").should route_to("friends#edit", :id => "1")
    end

    it "routes to #create" do
      post("/friends").should route_to("friends#create")
    end

    it "routes to #update" do
      put("/friends/1").should route_to("friends#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/friends/1").should route_to("friends#destroy", :id => "1")
    end

  end
end
