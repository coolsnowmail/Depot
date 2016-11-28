require "rails_helper"

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

  it "is invalid without title" do
    @product.title = nil
    # expect(@product.valid?).to eq(false)
    @product.valid?
    expect(@product.errors[:title]).to include("can't be blank")
  end

  it "is invalid without image_url" do
    @product.image_url = nil
    @product.valid?
    expect(@product.errors[:image_url]).to include("can't be blank")
  end

  it "is invalid without price" do
    @product.price = nil
    @product.valid?
    expect(@product.errors[:price]).to include("is not a number")
  end

  it "should validate price that more then 0,01" do
    @product.price = 0
    @product.valid?
    expect(@product.errors[:price]).to include("must be greater than or equal to 0.01")
  end

  it "should save" do
    expect(@product.save).to eq(true)
  end

  it "should validate title uniqness" do
    product1 = Product.new(title: @product.title, description: "description", image_url: "image_url1.png", price: 100)
    product1.valid?
    expect(product1.errors[:title]).to include("has already been taken")
  end

  it "should check if product1 was created" do
    @product = FactoryGirl.create(:product)
    expect(@product.persisted?).to eq(true)
  end

  it "should check latest method of product model" do
    @product1 = FactoryGirl.create(:product)
    @product2 = FactoryGirl.create(:product)
    @product3 = FactoryGirl.create(:product)
    expect(Product.all.latest).to eq(Product.order(:updated_at).last)
  end

    it "should check can be deleted a product with line item" do
    @line_item = FactoryGirl.create(:line_item)
    @product.line_items << @line_item
    @product.destroy
    expect(@product.errors[:base]).to include("существуют товарные позиции")
  end

end