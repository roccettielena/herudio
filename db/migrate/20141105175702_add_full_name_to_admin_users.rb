class AddFullNameToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :full_name, :string, null: false
  end
end
