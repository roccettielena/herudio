class CreateCoursesOrganizers < ActiveRecord::Migration
  def change
    create_table :courses_organizers, id: false do |t|
      t.integer :course_id, null: false
      t.integer :organizer_id, null: false
    end

    add_index :courses_organizers, [:course_id, :organizer_id]
  end
end
