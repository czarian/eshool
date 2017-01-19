class UserAnswer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  belongs_to :answer
  belongs_to :user_exam

  validates :question_id, presence: true, numericality: { only_integer: true }
  validates :answer_id, presence: true, numericality: { only_integer: true }
end
