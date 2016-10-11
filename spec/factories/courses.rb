FactoryGirl.define do
  factory :course do
    sequence(:name) { |n| "course name#{n}" }
    description  "Description of this course"
    status 1
  end
end
