class ChangeLessonCourseId < ActiveRecord::Migration
  def change
    remove_column :lessons, :Course_id
    add_reference :lessons, :course, index: true, foreign_key: true
  end
end
