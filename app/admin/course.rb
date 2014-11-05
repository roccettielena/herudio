ActiveAdmin.register Course do
  decorate_with CourseDecorator

  filter :category
  filter :name
  filter :location

  permit_params :name, :description, :location, :seats, :category_id, organizer_ids: []

  index do
    selectable_column
    id_column

    column :name
    column :location
    column :category do |course|
      link_to course.category.name, admin_course_category_path(course.category)
    end

    actions
  end

  show do |course|
    attributes_table do
      row :id
      row :name
      row :location

      row :category do |course|
        link_to course.category.name, admin_course_category_path(course.category)
      end

      row :seats

      row :organizers do
        course.organizers.map do |organizer|
          organizer.full_name
        end.join(', ')
      end

      row :description do
        course.description_html
      end
    end
  end

  form do |f|
    f.inputs t('activeadmin.course.panels.details') do
      f.input :category
      f.input :name
      f.input :description
      f.input :location
      f.input :seats
      f.input :organizers, as: :select, multiple: true, include_blank: true, collection: User.ordered_by_name.select(:id, :full_name)
    end

    f.actions
  end
end
