require "rails_helper"


RSpec.describe LineItem, :type => :model do

  describe 'validations line item' do
    it { should belong_to(:product) }
    it { should belong_to(:order) }
    it { should belong_to(:cart) }
  end

  describe 'custom method for line item' do
    let!(:product) { create(:product) }
    let!(:line_item1) { create(:line_item, product: product) }

    context 'should add line items from a cart' do
      it 'check total_price method' do
        expect(line_item1.total_price).to eq(product.price)
      end
    end
  end
end