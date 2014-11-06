ActiveAdmin.register User do
  permit_params :full_name, :email, :password, :password_confirmation, :group_id

  filter :full_name
  filter :email
  filter :group

  belongs_to :user_group, optional: true

  index do
    selectable_column
    id_column

    column :group do |user|
      link_to user.group.name, admin_user_group_path(user.group)
    end
    column :full_name
    column :email
    column :current_sign_in_at

    actions
  end

  show do |user|
    attributes_table do
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

  form do |f|
    f.inputs t('activeadmin.user.panels.details') do
      f.input :group
      f.input :full_name
      f.input :email
      f.input :password, required: false, hint: t('formtastic.hints.user.password')
      f.input :password_confirmation
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
