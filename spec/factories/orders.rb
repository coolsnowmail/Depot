FactoryGirl.define do
  factory :order, class: 'Order' do
    sequence(:name) { |i| "name#{i}"}
    address 'address'
    email 'email@mail.com'
    pay_type 2
  end
end