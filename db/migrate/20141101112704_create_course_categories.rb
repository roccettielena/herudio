class CreateCourseCategories < ActiveRecord::Migration
  def change
    create_table :course_categories do |t|
      t.string :name, null: false
    end

    add_index :course_categories, :name, unique: true
  end
end
