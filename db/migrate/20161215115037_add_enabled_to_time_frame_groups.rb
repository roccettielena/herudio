class AddEnabledToTimeFrameGroups < ActiveRecord::Migration
  def change
    add_column :time_frame_groups, :enabled, :boolean, default: true, null: false
  end
end
