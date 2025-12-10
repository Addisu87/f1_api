require 'rails_helper'

RSpec.describe "drivers/edit", type: :view do
  let(:driver) {
    Driver.create!(
      name: "MyString",
      code: "MyString",
      country: "MyString"
    )
  }

  before(:each) do
    assign(:driver, driver)
  end

  it "renders the edit driver form" do
    render

    assert_select "form[action=?][method=?]", driver_path(driver), "post" do
      assert_select "input[name=?]", "driver[name]"

      assert_select "input[name=?]", "driver[code]"

      assert_select "input[name=?]", "driver[country]"
    end
  end
end
