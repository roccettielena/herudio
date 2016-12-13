class AddGroupDateToTimeFrameGroups < ActiveRecord::Migration
  def change
    add_column :time_frame_groups, :group_date, :date, null: false
  end
end
