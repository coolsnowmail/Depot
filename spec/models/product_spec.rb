require "rails_helper"


RSpec.describe Product, :type => :model do

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:image_url) }
    it { should validate_numericality_of(:price) }
    it { should validate_uniqueness_of(:title) }

    it { should have_many(:line_items) }
    it { should have_many(:orders).through(:line_items) }

    it { is_expected.to callback(:ensure_not_referenced_by_any_line_item).before(:destroy) }
  end

  describe '#custom_method' do
    let!(:product1) { create(:product, updated_at: Time.now) }
    let!(:product2) { create(:product, updated_at: Time.now - 10.days) }
    let!(:product3) { create(:product, updated_at: Time.now - 20.days) }

    context 'should return latest product' do
      it '#latest should return latest product' do
        expect(Product.latest).to eq(product1)
      end
    end

    context 'check method ensure_not_referenced_by_any_line_item with a line_item' do
      before { product1.line_items << create(:line_item) }
      it '#should check if referenced by any line item' do
        expect(product1.send(:ensure_not_referenced_by_any_line_item)).to eq(false)
      end
    end

    context 'check method ensure_not_referenced_by_any_line_item with a line_item' do
      it '#should check if referenced by any line item' do
        expect(product1.send(:ensure_not_referenced_by_any_line_item)).to eq(true)
      end
    end
  end
end