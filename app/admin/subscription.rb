ActiveAdmin.register Subscription do
  decorate_with SubscriptionDecorator

  config.sort_order = :lesson_id
  config.filters = false

  actions :index, :new, :create, :destroy

  menu false

  permit_params :user_id, :lesson_id

  index do
    selectable_column
    id_column

    column :user, sortable: :user_id
    column :course, sortable: :course_id
    column :lesson, sortable: :lesson_id
    column :created_at

    actions
  end

  form do |f|
    f.object.user = User.find_by(id: params[:user_id]) if params[:user_id]

    f.inputs t('activeadmin.subscription.panels.details') do
      f.input :user, collection: User.order(full_name: :asc)
      f.input :lesson, collection: Lesson.order(id: :asc)
    end

    f.actions
  end

  controller do
    def destroy
      destroy! notice: t('activeadmin.subscription.destroy.notice') do
        request.referer
      end
    end
  end
end
