FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name  "Doe"
    email { "#{first_name}1.#{last_name}@example.com".downcase }
    password "password"
  end
end
