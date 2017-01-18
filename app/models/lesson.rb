class Lesson < ActiveRecord::Base
  belongs_to :course

  validates :name, presence: true, length: {minimum: 5, maximum: 255}
  validates :description, presence: true, length: {minimum: 5}

  scope :get_by_course_id, -> (course_id) {where(course_id: course_id)}

end
