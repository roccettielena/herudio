ActiveAdmin.register AdminUser do
  permit_params :full_name, :email, :password, :password_confirmation

  index do
    selectable_column
    id_column

    column :full_name
    column :email
    column :current_sign_in_at
    column :current_sign_in_ip

    actions
  end

  filter :email

  form do |f|
    f.inputs t('activeadmin.admin_user.panels.details') do
      f.input :full_name
      f.input :email
      f.input :password, required: false, hint: t('formtastic.hints.admin_user.password')
      f.input :password_confirmation, required: false
    end

    f.actions
  end

  show do |admin_user|
    attributes_table do
      row :id
      row :full_name
      row :email
      row :current_sign_in_at
      row :current_sign_in_at
      row :sign_in_count
      row :created_at
      row :updated_at
    end
  end

  controller do
    def update
      if params[:admin_user][:password].blank?
        params[:admin_user].delete('password')
        params[:admin_user].delete('password_confirmation')
      end

      super
    end
  end
end
