class AddDefaultStatusToCourse < ActiveRecord::Migration
  def change
    change_column :courses, :status, :integer, :default => 1
  end
end
