module ApplicationHelper
  def check_for_new_notifications
    return false unless current_user

    current_user.received_notifications.where(read: false).exists?
  end
end
