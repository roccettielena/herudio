ActiveAdmin.register Subscription do
  decorate_with SubscriptionDecorator

  belongs_to :course, optional: true

  config.sort_order = :lesson_id

  filter :user, collection: ->{ User.ordered_by_name.select(:id, :full_name) }

  navigation_menu false

  actions :all, except: [:show, :new, :create, :edit, :update]

  index do
    selectable_column
    id_column

    column :user, sortable: :user_id
    column :course, sortable: :course_id
    column :lesson, sortable: :lesson_id
    column :created_at

    actions
  end
end
