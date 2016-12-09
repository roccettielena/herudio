class CreateAuthorizedUsers < ActiveRecord::Migration
  def change
    create_table :authorized_users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :group_id, null: false
      t.string :birth_location, null: false
      t.date :birth_date, null: false

      t.timestamps null: false

      t.foreign_key :user_groups, column: :group_id, on_delete: :cascade
      t.index :group_id
    end
  end
end
