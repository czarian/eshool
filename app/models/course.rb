class Course < ActiveRecord::Base
  has_many :lessons
  has_many :exams
  enum status: [:inactive, :active]

  validates :name, presence: true, length: {minimum: 5, maximum: 255},
                    :format => { :with => /\A[A-Za-z0-9 ]+\Z/ }

  validates :description, presence: true, length: {minimum: 10}

  validates :status, inclusion: { in: ["inactive", "active"] }


  scope :get_active, -> {where("status = 1") }
end
