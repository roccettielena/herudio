ActiveAdmin.register User do
  decorate_with UserDecorator

  permit_params :full_name, :email, :password, :password_confirmation, :group_id

  filter :full_name
  filter :email
  filter :group

  belongs_to :user_group, optional: true

  index do
    selectable_column
    id_column

    column :group, sortable: :group_id do |user|
      link_to user.group.name, admin_user_group_path(user.group)
    end
    column :full_name
    column :email
    column :current_sign_in_at

    actions
  end

  show do |user|
    panel t('activeadmin.user.panels.details') do
      attributes_table_for user do
        row :id
        row :group
        row :full_name
        row :email
        row :current_sign_in_at
        row :current_sign_in_ip
        row :sign_in_count
        row :created_at
        row :updated_at
      end
    end

    panel t('activeadmin.user.panels.courses') do
      table_for user.courses do
        column t('activerecord.attributes.course.id'), :id
        column t('activerecord.attributes.course.name'), :name do |course|
          link_to course.name, admin_course_path(course)
        end
        column t('activerecord.attributes.course.category'), :category
        column t('activerecord.attributes.course.location'), :location
      end
    end

    panel t('activeadmin.user.panels.subscriptions') do
      table_for user.subscriptions do
        column t('activerecord.attributes.subscription.id'), :id
        column t('activerecord.attributes.subscription.course'), :course
        column t('activerecord.attributes.subscription.lesson'), :lesson
        column t('activerecord.attributes.subscription.created_at'), :screated_at
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

  form do |f|
    f.inputs t('activeadmin.user.panels.details') do
      f.input :group
      f.input :full_name
      f.input :email
      f.input :password, required: f.object.new_record?, hint: f.object.persisted?
      f.input :password_confirmation, required: f.object.new_record?
    end

    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end

      super
    end
  end
end
