class AddAuthorizationColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string, null: false
    add_column :users, :birth_date, :date, null: false
    add_column :users, :birth_location, :string, null: false
    remove_column :users, :full_name, :string, null: false
  end
end
