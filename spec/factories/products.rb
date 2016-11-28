FactoryGirl.define do
  factory :product do
    sequence(:title) { |i| "title#{i}"}
    # title "title"
    description "description"
    image_url "image_url.png"
    price 1
  end

  # factory :product do |p|
  #   sequence(:title) { |i| "title#{i}"}
  #   description "description1"
  #   image_url "image_url1.png"
  #   price 100
  # end
end