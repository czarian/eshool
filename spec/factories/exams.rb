FactoryGirl.define do
  factory :exam do
    sequence(:title) { |n| "Exam #{n} course #{course.id} name"}
    status 2
    association :course
  end
end
