class NotificationsController < ApplicationController
  before_action :correct_user

  def index
    if (current_user)
      @notifications = current_user.received_notifications.reverse_order.page(params[:page])
      @prev_notifications_viewed_at = current_user.notifications_viewed_at # store former notifications viewed at state
      current_user.notifications_viewed_at = DateTime.current # update viewed at time
      current_user.save
    end
  end

  protected

    # Protect notifications from unauthorized users
    def correct_user
      @is_user = current_user.id === params[:id].to_i
      unless @is_user
        redirect_to user_account_path(current_user), notice: "you don't have access to that page"
      end
    end
end
