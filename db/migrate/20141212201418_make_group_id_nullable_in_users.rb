class MakeGroupIdNullableInUsers < ActiveRecord::Migration
  def up
    change_column :users, :group_id, :integer, null: true
  end

  def down
    change_column :users, :group_id, :integer, null: false
  end
end
