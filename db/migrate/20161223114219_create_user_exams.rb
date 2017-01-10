class CreateUserExams < ActiveRecord::Migration
  def change
    create_table :user_exams do |t|
      t.references :user, index: true, foreign_key: true
      t.references :exam, index: true, foreign_key: true
      t.integer :score
      t.boolean :passed

      t.timestamps null: false
    end
  end
end
