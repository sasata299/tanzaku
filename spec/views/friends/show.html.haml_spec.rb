require 'spec_helper'

describe "friends/show.html.haml" do
  before(:each) do
    @friend = assign(:friend, stub_model(Friend))
  end

  it "renders attributes in <p>" do
    render
  end
end
