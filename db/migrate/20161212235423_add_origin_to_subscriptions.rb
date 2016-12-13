class AddOriginToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :origin, :string

    reversible do |dir|
      dir.up do
        Subscription.update_all origin: 'manual'
      end

      change_column :subscriptions, :origin, :string, null: false
    end
  end
end
