class AddNameToTimeFrameGroup < ActiveRecord::Migration
  def change
    add_column :time_frame_groups, :label, :string

    reversible do |dir|
      dir.up do
        TimeFrameGroup.all.find_each do |time_frame_group|
          time_frame_group.update_column :label, time_frame_group.id
        end

        change_column :time_frame_groups, :label, :string, null: false
      end
    end
  end
end
