class Course < ActiveRecord::Base
  has_many :lessons
  has_many :exams
  enum status: [:inactive, :active]


  scope :get_active, -> {where("status = 1") }
end
