require 'rails_helper'

RSpec.describe "circuits/new", type: :view do
  before(:each) do
    assign(:circuit, Circuit.new(
      name: "MyString",
      location: "MyString"
    ))
  end

  it "renders new circuit form" do
    render

    assert_select "form[action=?][method=?]", circuits_path, "post" do

      assert_select "input[name=?]", "circuit[name]"

      assert_select "input[name=?]", "circuit[location]"
    end
  end
end
