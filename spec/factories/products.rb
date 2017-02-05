FactoryGirl.define do
  factory :product, class: 'Product' do
    sequence(:title) { |i| "title#{i}"}
    description "description"
    image_url "image_url.png"
    price 99.99
  end
end