class MakeUserGroupNotNullable < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up { change_column :users, :group_id, :integer, null: false }
      dir.down { change_column :users, :group_id, :integer, null: true }
    end
  end
end
