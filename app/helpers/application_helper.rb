module ApplicationHelper
  def check_for_new_notifications
    return false unless current_user

    viewed_at = current_user.notifications_viewed_at
    current_user.received_notifications.where('created_at > ?', viewed_at).exists?
  end
end
