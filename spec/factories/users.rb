FactoryGirl.define do
  factory :user, class: 'User' do
    sequence(:name) { |i| "name#{i}" }
    password "password"
    password_confirmation "password"
  end
end