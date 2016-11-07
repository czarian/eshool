class ChangeUserRoleDefault < ActiveRecord::Migration
  def change
    change_column :users, :role, :string, :default => 'regullar'
  end
end
