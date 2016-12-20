FactoryGirl.define do
  factory :question do
    sequence(:content) { |n| "Question number #{n} "}
    association :exam
    answers_attributes { [
                          FactoryGirl.attributes_for(:answer),
                          FactoryGirl.attributes_for(:answer),
                          FactoryGirl.attributes_for(:answer, correct: true)]
     }

  end
end
