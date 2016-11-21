require "spec_helper"

# describe Product do

#     it 'is invalid without title' do
#       product = FactoryGirl.build(:product)
#       expect(product).to be_valid
#   end

RSpec.describe Product, :type => :model do
  before(:each) do
    @product = FactoryGirl.create(:product)
  end
  # it "Product by last name" do
  #   product = Product.create!(title: "title", price: 1, description: "description", image_url: "image_url.png")
  #   product.title = nil

  #   expect(product.valid?).to eq(false)
  # end

  it "Product by last name" do
    @product.title = nil

    expect(@product.valid?).to eq(false)
  end
end