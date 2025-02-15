FactoryBot.define do

  factory :user do
    sequence(:login) { |n| "user#{n}"} 
    password { 'testing' }
    password_confirmation { 'testing' }
  end
end
