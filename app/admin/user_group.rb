# frozen_string_literal: true
ActiveAdmin.register UserGroup do
  permit_params :name

  filter :name

  action_item :users, only: :show do
    link_to t('activeadmin.user_group.actions.users'), admin_user_group_users_path(user_group)
  end

  index do
    selectable_column
    id_column

    column :name

    actions
  end

  show do |_group|
    attributes_table do
      row :id
      row :name
    end
  end

  form do |f|
    f.inputs t('activeadmin.user_group.panels.details') do
      f.input :name
    end

    f.actions
  end

  controller do
    rescue_from ActiveRecord::DeleteRestrictionError do
      flash[:error] = t('activeadmin.user_group.destroy.restricted')
      redirect_to :back
    end
  end
end
