class Question < ActiveRecord::Base
  belongs_to :exam
  has_many :answers

  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  scope :get_by_exam_id, -> (exam_id) {where(exam_id: exam_id)}

end
