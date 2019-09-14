# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  after_action :notify, only: [:create]

  protected

  def notify
    return if current_user.blank?
    return if Rails.env.production?
    Notification.create(user_id: current_user.id, message: 'Your 4 digit PIN number is ' + current_user.pin + ', keep out of reach of children')
    ApplicationCable::NotificationsChannel.broadcast_to(
      current_user,
      notification: 'new notification'
    )
  end
end
