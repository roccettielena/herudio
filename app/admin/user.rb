# frozen_string_literal: true
ActiveAdmin.register User do
  decorate_with UserDecorator

  menu parent: 'Utenti'

  permit_params(
    :first_name, :last_name, :birth_location, :birth_date, :email, :password,
    :password_confirmation, :group_id
  )

  filter :first_name
  filter :last_name
  filter :email
  filter :group

  belongs_to :user_group, optional: true

  member_action :confirm, method: :put do
    resource.confirm
    redirect_to resource_path, notice: "L'utente è stato confermato."
  end

  member_action :resend_confirmation_email, method: :put do
    resource.send_confirmation_instructions
    redirect_to resource_path, notice: "L'email di conferma è stata rimandata."
  end

  member_action :invite, method: :post do
    resource.invite!
    redirect_to resource_path, notice: "L'utente è stato invitato."
  end

  collection_action :fill_subscriptions, method: :post do
    FillSubscriptionsJob.perform_later
    redirect_to collection_path,
      notice: 'Il sistema sta completando le iscrizioni. Ci vorrà qualche minuto.'
  end

  action_item :new_subscription, only: :show do
    unless User.advisory_lock_exists?(FillSubscriptions::ADVISORY_LOCK_NAME)
      link_to('Iscrivi Utente', new_admin_subscription_path(user_id: user.id))
    end
  end

  action_item :fill_subscriptions, only: :index do
    unless User.advisory_lock_exists?(FillSubscriptions::ADVISORY_LOCK_NAME)
      link_to('Completa Iscrizioni', fill_subscriptions_admin_users_path, method: :post)
    end
  end

  action_item :confirm, only: :show do
    if ENV.fetch('REGISTRATION_TYPE') == 'regular' && !user.confirmed?
      link_to('Conferma Utente', confirm_admin_user_path(user), method: :put)
    end
  end

  action_item :resend_confirmation_email, only: :show do
    if ENV.fetch('REGISTRATION_TYPE') == 'regular' && !user.confirmed?
      link_to('Rimanda Email di Conferma', confirm_admin_user_path(user), method: :put)
    end
  end

  action_item :invite, only: :show do
    if ENV.fetch('REGISTRATION_TYPE') == 'invitation' && !user.invitation_accepted?
      link_to('Invita Utente', invite_admin_user_path(user), method: :post)
    end
  end

  index do
    selectable_column
    id_column

    column :group, sortable: :group_id
    column :first_name
    column :last_name
    column :email
    column :current_sign_in_at

    column :status do |user|
      case ENV.fetch('REGISTRATION_TYPE')
      when 'invitation'
        if user.invitation_accepted?
          status_tag 'Confermato', :ok
        else
          status_tag 'Invitato', :standby
        end
      when 'regular'
        if user.confirmed?
          status_tag 'Confermato', :ok
        else
          status_tag 'Da confermare', :standby
        end
      end
    end

    actions
  end

  show do |user|
    columns do
      column do
        panel t('activeadmin.user.panels.details') do
          attributes_table_for user do
            row :id
            row :group
            row :first_name
            row :last_name
            row :birth_date
            row :birth_location
            row :email
            row :unconfirmed_email if user.unconfirmed_email.present?
          end
        end
      end

      column do
        panel t('activeadmin.user.panels.stats') do
          attributes_table_for user do
            row :status do
              case ENV.fetch('REGISTRATION_TYPE')
              when 'invitation'
                if user.invitation_accepted?
                  status_tag 'Confermato', :ok
                else
                  status_tag 'Invitato', :standby
                end
              when 'regular'
                if user.confirmed?
                  status_tag 'Confermato', :ok
                else
                  status_tag 'Da confermare', :standby
                end
              end
            end
            row :current_sign_in_at
            row :current_sign_in_ip
            row :created_at
            row :updated_at
          end
        end
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
        column t('activerecord.attributes.subscription.created_at'), :created_at
        column t('activerecord.attributes.subscription.origin'), :origin
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
      f.input :group, collection: UserGroup.ordered_by_name, required: false
      f.input :first_name
      f.input :last_name
      f.input :birth_date, start_year: Time.zone.today.year - 100, end_year: Time.zone.today.year
      f.input :birth_location
      f.input :email
      f.input :password, required: f.object.new_record?, hint: f.object.persisted?
      f.input :password_confirmation, required: f.object.new_record?
    end

    f.actions
  end

  controller do
    def create
      @user = User.new(permitted_params[:user])
      @user.skip_confirmation!

      create!
    end

    def update
      if params[:user][:password].blank?
        params[:user].delete('password')
        params[:user].delete('password_confirmation')
      end

      @user = User.find(params[:id])
      @user.skip_authorized_user_validation
      @user.skip_reconfirmation!

      update!
    end
  end
end
