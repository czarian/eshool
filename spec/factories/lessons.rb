FactoryGirl.define do
  factory :lesson do
    sequence(:name) { |n| "Lesson #{n} course #{course.id} name"}
    sequence(:description) { |n| "Lesson #{n} course #{course.id} description"}
    association :course
  end

end
