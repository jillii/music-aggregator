class NotificationsController < ApplicationController
  before_action :is_current_user

  def index
    @notifications = current_user.received_notifications.reverse_order.page(params[:page])
    @prev_notifications_viewed_at = current_user.notifications_viewed_at # store former notifications viewed at state
    current_user.notifications_viewed_at = DateTime.current # update viewed at time
    current_user.save
  end

  # GET /notification/:id
  def show
    @notification = Notification.find(params[:id])
  end

  protected

    # Protect notifications from unauthorized users
    def is_current_user
      unless current_user
        redirect_to user_account_path(current_user), notice: "you need to be signed in to see that page"
      end
    end
end
