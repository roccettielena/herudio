# frozen_string_literal: true
ActiveAdmin.register TimeFrameGroup do
  decorate_with TimeFrameGroupDecorator

  menu parent: 'Corsi'

  filter :group_date
  filter :ends_at

  permit_params do
    [:label, :enabled].tap do |params_to_permit|
      params_to_permit << :group_date if params[:action].in?(%w(new create))
    end
  end

  actions :all

  index do
    selectable_column
    id_column

    column :label
    column :group_date
    column :enabled

    actions
  end

  show do |time_frame_group|
    panel t('activeadmin.time_frame_group.panels.details') do
      attributes_table_for time_frame_group do
        row :id
        row :label
        row :group_date
        row :enabled
      end
    end

    panel t('activeadmin.time_frame_group.panels.time_frames') do
      table_for time_frame_group.time_frames do
        column t('activerecord.attributes.time_frame.id'), :id
        column t('activerecord.attributes.time_frame.starts_at'), :starts_at do |time_frame|
          link_to time_frame.starts_at, admin_time_frame_path(time_frame)
        end
        column t('activerecord.attributes.time_frame.ends_at'), :ends_at do |time_frame|
          link_to time_frame.ends_at, admin_time_frame_path(time_frame)
        end
        column :enabled
      end
    end
  end

  form do |f|
    f.inputs t('activeadmin.time_frame_group.panels.details') do
      f.input :label
      f.input :group_date, disabled: resource.persisted?
      f.input :enabled
    end

    f.actions
  end
end
