class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.text :description
      t.references :Course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
