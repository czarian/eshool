class Lesson < ActiveRecord::Base
  belongs_to :course

  scope :get_by_course_id, -> (course_id) {where(course_id: course_id)}

end
