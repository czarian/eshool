class AddDefaultStatusToExam < ActiveRecord::Migration
  def change
    change_column :exams, :status, :integer, :default => 1
  end
end
