require 'rails_helper'

RSpec.describe "drivers/show", type: :view do
  before(:each) do
    assign(:driver, Driver.create!(
      name: "Name",
      code: "Code",
      country: "Country"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/Country/)
  end
end
