ActiveAdmin.register Subscription do
  decorate_with SubscriptionDecorator

  config.sort_order = :lesson_id
  config.filters = false

  actions :destroy

  menu false

  index do
    selectable_column
    id_column

    column :user, sortable: :user_id
    column :course, sortable: :course_id
    column :lesson, sortable: :lesson_id
    column :created_at

    actions
  end

  controller do
    def destroy
      destroy! notice: t('activeadmin.subscription.destroy.notice') do
        admin_course_path(@subscription.lesson.course)
      end
    end
  end
end
