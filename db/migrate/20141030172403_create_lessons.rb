class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.integer :course_id, null: false
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
    end
  end
end
