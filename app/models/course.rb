class Course < ActiveRecord::Base

  enum status: [:inactive, :active]

  scope :get_active, -> {where("status = 1") }
end
