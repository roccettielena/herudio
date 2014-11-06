ActiveAdmin.register CourseCategory do
  permit_params :name

  filter :name

  index do
    selectable_column
    id_column

    column :name

    actions
  end

  show do |category|
    attributes_table do
      row :id
      row :name
    end
  end

  form do |f|
    f.inputs t('activeadmin.course_category.panels.details') do
      f.input :name
    end

    f.actions
  end

  controller do
    rescue_from ActiveRecord::DeleteRestrictionError do
      flash[:error] = t('activeadmin.course_category.destroy.restricted')
      redirect_to :back
    end
  end
end
