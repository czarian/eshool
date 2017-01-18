class Answer < ActiveRecord::Base
  belongs_to :question

  validates :content, presence: true, length: {minimum: 5, maximum: 255 }
  validates :correct, inclusion: { in: [true, false] }

end
