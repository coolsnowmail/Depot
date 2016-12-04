require "rails_helper"


RSpec.describe Order, :type => :model do

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:email) }
    it do
      should define_enum_for(:pay_type).with(["Check", "Credit card", "Purchase order"])
    end
    it { should have_many(:line_items).dependent(:destroy) }
  end

  describe 'custom method for order' do
    let!(:order) { create(:order) }
    let!(:cart) { create(:cart) }

    context 'should add line items from a cart' do
      it '#latest should return latest product' do
        order.add_line_items_from_cart(cart)
        expect(order.line_items).to eq(cart.line_items)
      end
    end
  end
end