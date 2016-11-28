require "rails_helper"

RSpec.describe Cart, :type => :model do
  before(:each) do
    @cart = FactoryGirl.create(:cart)
  end

  it "tests if cart can be created" do
    expect(@cart.persisted?).to eq(true)
  end

  it "tests line items dependent destroy" do
    @line_item = FactoryGirl.create(:line_item)
    @line_item1 = FactoryGirl.create(:line_item)
    cart_id = @cart.id
    @cart.line_items = LineItem.all
    @cart.destroy
    expect(LineItem.where(cart_id: cart_id).size).to eq(0)
  end

  it "chould check add product method" do
    @product = FactoryGirl.create(:product)
    @cart.add_product(@product.id)
    expect(@cart.line_items[0].product_id).to eq(@product.id)
  end

    it "chould check add product method 2" do
    # @line_item = FactoryGirl.create(:line_item)
    @product = FactoryGirl.create(:product)
    # @line_item.product_id = @product.id
    # @line_item.cart_id = @cart.id
    # @cart.line_items << @line_item
    # @line_item.save
    # @cart.save
    # @product.line_items << @line_item
    # @line_item1.product_id = @product.id
    # @line_item1.cart_id = @cart.id
    # @cart.line_items << @line_item1
    @cart.add_product(@product.id)
    @cart.line_items[0].save
    @cart.save
    @cart.add_product(@product.id)
    # @cart.add_product(@product.id)
    expect(@cart.line_items).to eq(1)
    # expect(@cart.line_items.first).to eq(@line_item)
  end

end