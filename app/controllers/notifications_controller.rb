class NotificationsController < ApplicationController
  before_action :is_current_user

  def index
    @notifications = current_user.received_notifications.reverse_order.page(params[:page])
    @collab_requests = current_user.collab_requests_received.reverse_order.page(params[:page])
  end

  # GET /notification/:id
  def show
    @notification = Notification.find(params[:id])

    unless @notification.recipient_id == current_user.id
      redirect_to user_notifications_path, notice: "you don't have access to that page"
    end

    if !@notification.read
      @notification.update(read: true)
      Turbo::StreamsChannel.broadcast_replace_to("notification_#{@notification.id}", target: "notification_#{@notification.id}")
    end
  end

  def read
    @notification = Notification.find(params[:id])
    @notification.update(read: true)

    respond_to do |format|
      @notification.save
      format.html { redirect_back_or_to user_notifications_path }
    end
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.html { redirect_back_or_to user_notifications_path }
    end
  end

  protected

    # Protect notifications from unauthorized users
    def is_current_user
      unless current_user
        redirect_to root_path, notice: "you need to be signed in to see that page"
      end
    end
end
