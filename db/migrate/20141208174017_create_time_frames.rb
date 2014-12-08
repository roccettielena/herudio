class CreateTimeFrames < ActiveRecord::Migration
  def change
    create_table :time_frames do |t|
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
    end
  end
end
