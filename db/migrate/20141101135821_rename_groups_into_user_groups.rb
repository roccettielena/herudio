class RenameGroupsIntoUserGroups < ActiveRecord::Migration
  def change
    rename_table :groups, :user_groups
  end
end
