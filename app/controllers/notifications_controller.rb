class NotificationsController < ApplicationController
  before_action :is_current_user

  def index
    @notifications = current_user.received_notifications.reverse_order.page(params[:page])
  end

  # GET /notification/:id
  def show
    @notification = Notification.find(params[:id])

    if !@notification.read
      @notification.update(read: true)
      Turbo::StreamsChannel.broadcast_replace_to("notification_#{@notification.id}", target: "notification_#{@notification.id}")
    end
  end

  protected

    # Protect notifications from unauthorized users
    def is_current_user
      unless current_user
        redirect_to user_account_path(current_user), notice: "you need to be signed in to see that page"
      end
    end
end
