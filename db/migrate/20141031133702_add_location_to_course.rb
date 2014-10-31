class AddLocationToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :location, :string, null: false
  end
end
