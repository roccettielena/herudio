class CreateTimeFrameGroups < ActiveRecord::Migration
  def change
    create_table :time_frame_groups do |t|

      t.timestamps null: false
    end
  end
end
