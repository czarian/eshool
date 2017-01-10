FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name  "Doe"
    sequence(:email) { |n| "#{first_name}#{n}.#{last_name}@example.com".downcase }
    #email { "#{first_name}1.#{last_name}@example.com".downcase }
    password "password"
    role "admin"
  end
end
