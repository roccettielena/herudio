class AddAuthorizedUserToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :authorized_user, index: true, foreign_key: { on_delete: :cascade }

    reversible do |dir|
      dir.up do
        User.find_each do |user|
          user.update_column :authorized_user_id, user.authorized_user&.id
        end
      end
    end
  end
end
