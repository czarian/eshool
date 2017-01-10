class AddDefaultsTuUserExams < ActiveRecord::Migration
  def change
    change_column :user_exams, :score, :integer, :default => 0
    change_column :user_exams, :passed, :boolean, :default => false
  end
end
