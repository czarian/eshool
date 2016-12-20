FactoryGirl.define do
  factory :answer do
    sequence(:content) { |n| "Answer #{n} question"}
    correct false
    association :question
  end
end
