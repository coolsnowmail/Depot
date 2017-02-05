FactoryGirl.define do
  factory :cart do
    after(:create) do |cart|
      product1 = create(:product)
      product2 = create(:product)
      cart.line_items << create(:line_item, product_id: product1.id)
      cart.line_items << create(:line_item, product_id: product2.id)
    end
  end
end