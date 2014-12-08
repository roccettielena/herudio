class AddTimeFrameIdToLessons < ActiveRecord::Migration
  def change
    remove_column :lessons, :starts_at, :datetime, null: false
    remove_column :lessons, :ends_at, :datetime, null: false
    add_column :lessons, :time_frame_id, :integer, null: false
  end
end
