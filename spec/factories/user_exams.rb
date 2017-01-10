FactoryGirl.define do
  factory :user_exam do
    user
    exam
    score 0
    passed false
  end
end
