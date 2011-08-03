require 'spec_helper'

describe "friends/index.html.haml" do
  before(:each) do
    assign(:friends, [
      stub_model(Friend),
      stub_model(Friend)
    ])
  end

  it "renders a list of friends" do
    render
  end
end
