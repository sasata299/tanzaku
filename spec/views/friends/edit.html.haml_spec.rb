require 'spec_helper'

describe "friends/edit.html.haml" do
  before(:each) do
    @friend = assign(:friend, stub_model(Friend))
  end

  it "renders the edit friend form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => friends_path(@friend), :method => "post" do
    end
  end
end
