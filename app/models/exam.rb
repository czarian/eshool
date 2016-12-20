class Exam < ActiveRecord::Base
  belongs_to :course
  has_many :exams

  enum status: [:inactive, :inProgress, :active]

  scope :get_active, -> {where("status = 2") }

end

