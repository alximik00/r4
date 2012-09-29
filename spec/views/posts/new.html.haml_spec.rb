require 'spec_helper'

describe "posts/new.html.haml" do
  before(:each) do
    assign(:post, stub_model(Post,
      :user_id => 1,
      :description => "MyString",
      :body => "MyText",
      :title => "MyString"
    ).as_new_record)
  end

  it "renders new post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => posts_path, :method => "post" do
      assert_select "input#post_user_id", :name => "post[user_id]"
      assert_select "input#post_description", :name => "post[description]"
      assert_select "textarea#post_body", :name => "post[body]"
      assert_select "input#post_title", :name => "post[title]"
    end
  end
end
