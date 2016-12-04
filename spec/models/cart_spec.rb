require "rails_helper"


RSpec.describe Cart, :type => :model do

  describe 'validations' do
    it { should have_many(:line_items).dependent(:destroy) }
  end

  describe 'custom method for cart' do
    let!(:cart) { create(:cart) }
    let!(:product) { create(:product) }
    # let!(:line_item) { create(:line_item, cart: cart, product: product) }
    # let!(:product1) { create(:product) }
    # let!(:line_item1) { create(:line_item, cart: cart, product: product1, quantity: 2) }

   context 'should check total_price method' do
    it 'should summ price' do
      expect(cart.total_price).to eq(199.98)
    end
  end

    context 'should add_product method' do
      it 'should add product with line item' do
        cart.add_product(product.id)
        cart.line_items[2].save
        expect(cart.line_items.find_by(product_id: product.id).present?).to eq(true)
      end
    end

    context 'should add_product method 2' do
      it 'should add product with line item quantity equal 2' do
        cart.add_product(product.id).save
        cart.add_product(product.id).save
        expect( cart.line_items.find_by(product_id: product.id).reload.quantity).to eq(2)
      end
    end
  end
end