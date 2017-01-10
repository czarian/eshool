class UserExam < ActiveRecord::Base
  belongs_to :user
  belongs_to :exam
  has_many :user_answers

  accepts_nested_attributes_for :user_answers, :allow_destroy => true

  scope :get_by_user_id_exam_id, -> (user_id, exam_id) {where(:user_id => user_id, :exam_id => exam_id) }
end
