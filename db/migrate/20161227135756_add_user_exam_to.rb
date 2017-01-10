class AddUserExamTo < ActiveRecord::Migration
  def change
    add_column :user_answers, :user_exam_id, :integer, index: true, foreign_key: true
  end
end
