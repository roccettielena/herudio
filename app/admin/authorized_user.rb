# frozen_string_literal: true
ActiveAdmin.register AuthorizedUser do
  # decorate_with AuthorizedUserDecorator

  permit_params :first_name, :last_name, :birth_location, :birth_date, :group_id

  filter :first_name
  filter :last_name
  filter :birth_location
  filter :birth_date
  filter :group

  belongs_to :user_group, optional: true

  index do
    selectable_column
    id_column

    column :group, sortable: :group_id
    column :first_name
    column :last_name
    column :birth_location
    column :birth_date

    actions
  end

  form do |f|
    f.inputs t('activeadmin.user.panels.details') do
      f.input :group, collection: UserGroup.ordered_by_name, required: false
      f.input :first_name
      f.input :last_name
      f.input :last_name
      f.input :birth_date
      f.input :birth_location
    end

    f.actions
  end
end
