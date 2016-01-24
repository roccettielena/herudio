ActiveAdmin.register Course do
  decorate_with CourseDecorator

  filter :category
  filter :name
  filter :location
  filter :status, as: :select, collection: Course.status.options

  permit_params :name, :description, :location, :seats, :category_id, :status, organizer_ids: [], lessons_attributes: [
    :id, :time_frame_id, :_destroy
  ]

  index do
    selectable_column
    id_column

    column :name
    column :location
    column :category, sortable: :category_id do |course|
      link_to course.category.name, admin_course_category_path(course.category)
    end
    column :status, :admin_status, sortable: :status

    actions
  end

  show do |course|
    panel t('activeadmin.course.panels.details') do
      attributes_table_for course do
        row :id
        row :name
        row :location

        row :category do |course|
          link_to course.category.name, admin_course_category_path(course.category)
        end
        row :status do |course|
          course.admin_status
        end

        row :seats

        row :organizers do
          course.organizers.map do |organizer|
            link_to organizer.full_name, admin_user_path(organizer)
          end.join(', ').html_safe
        end

        row :description do
          course.description_html
        end
      end
    end

    panel t('activeadmin.course.panels.lessons') do
      table_for course.lessons do |lesson|
        column t('activerecord.attributes.lesson.id'), :id
        column t('activerecord.attributes.lesson.starts_at'), :starts_at
        column t('activerecord.attributes.lesson.ends_at'), :ends_at
        column t('activerecord.attributes.lesson.taken_seats'), :taken_seats
        column t('activerecord.attributes.lesson.available_seats'), :available_seats
        column do |lesson|
          link_to(
            t('activeadmin.lesson.actions.subscribe'),
            new_admin_subscription_path(lesson_id: lesson.id)
          )
        end
      end
    end

    course.lessons.each do |lesson|
      panel t('activeadmin.course.panels.subscriptions', starts_at: lesson.starts_at, ends_at: lesson.ends_at) do
        table_for lesson.subscriptions do
          column t('activerecord.attributes.subscription.id'), :id
          column t('activerecord.attributes.subscription.user'), :user
          column t('activerecord.attributes.subscription.created_at'), :created_at
          column do |subscription|
            link_to(
              t('activeadmin.subscription.actions.destroy'),
              admin_subscription_path(subscription),
              method: :delete,
              data: { confirm: t('activeadmin.subscription.destroy.confirm') }
            )
          end
        end
      end
    end
  end

  form do |f|
    f.inputs t('activeadmin.course.panels.details') do
      f.input :category
      f.input :status
      f.input :name
      f.input :description
      f.input :location
      f.input :seats
      f.input :organizers, as: :select, multiple: true, include_blank: true, collection: User.ordered_by_name.select(:id, :full_name)
    end

    f.has_many :lessons, heading: t('activeadmin.course.panels.lessons'), allow_destroy: true do |a|
      a.input :time_frame, label: t('formtastic.labels.lesson.time_frame'), collection: TimeFrame.all.decorate
    end

    f.actions
  end
end
