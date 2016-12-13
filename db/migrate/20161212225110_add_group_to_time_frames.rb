class AddGroupToTimeFrames < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        add_column :time_frames, :group_id, :integer

        TimeFrame.find_each do |time_frame|
          time_frame.update_column :group_id, TimeFrameGroup.find_or_create_by(
            group_date: time_frame.starts_at.to_date
          ).id
        end

        change_column :time_frames, :group_id, :integer, null: false

        add_foreign_key :time_frames, :time_frame_groups, column: :group_id, on_delete: :cascade
        add_index :time_frames, :group_id
      end

      dir.down do
        remove_column :time_frames, :group_id
      end
    end
  end
end
