require 'spec_helper'

describe "friends/new.html.haml" do
  before(:each) do
    assign(:friend, stub_model(Friend).as_new_record)
  end

  it "renders new friend form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => friends_path, :method => "post" do
    end
  end
end
