class Course < ActiveRecord::Base
  has_many :lessons
  enum status: [:inactive, :active]


  scope :get_active, -> {where("status = 1") }
end
