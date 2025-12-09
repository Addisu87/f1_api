require 'rails_helper'

RSpec.describe "circuits/edit", type: :view do
  let(:circuit) {
    Circuit.create!(
      name: "MyString",
      location: "MyString"
    )
  }

  before(:each) do
    assign(:circuit, circuit)
  end

  it "renders the edit circuit form" do
    render

    assert_select "form[action=?][method=?]", circuit_path(circuit), "post" do

      assert_select "input[name=?]", "circuit[name]"

      assert_select "input[name=?]", "circuit[location]"
    end
  end
end
