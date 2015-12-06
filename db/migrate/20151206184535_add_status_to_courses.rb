class AddStatusToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :status, :string, null: false, default: 'proposed'
  end
end
