class CollabRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @collab_requests = current_user.collab_requests_received.reverse_order.page(params[:page])
  end
  # playlists/:id/collab_requests/create
  def create
    playlist = Playlist.find(params[:id])
    receiver = User.find(playlist.user_id)
    collab_request = CollabRequest.new(sender_id: current_user.id, reciever_id: receiver.id, playlist: playlist)

    respond_to do |format|
      if collab_request.save
        format.html { redirect_to playlist_path(playlist.id) }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: collab_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @collab_request = CollabRequest.find(params[:id])
    @sender = User.find(@collab_request.sender_id)
    @playlist = Playlist.find(@collab_request.playlist_id)

    unless current_user.id == @collab_request.reciever_id
      redirect_to user_notifications_path, notice: "You don't have access to that page"
    end
  end

  def accept_request
    request = CollabRequest.find(params[:id])
    playlist = Playlist.find(params[:playlist])
    editor = User.find(params[:user])
    owner = User.find(playlist.user_id)

    notification = Notification.new(
      message: "<a href='/users/#{owner.id}/'>#{owner.username}</a>has accepted your request to collab on <a href='/playlists/#{playlist.id}'>#{playlist.title}</a>",
      sender_id: owner.id,
      recipient_id: editor.id,
      read: false
    )

    begin
      playlist.editors.push(editor)
    rescue Exception => e
      redirect_to collab_request_view_path(request.id), notice: 'Could not add user'
    else
      request.destroy
      notification.save
      redirect_to playlist_path(playlist), notice: "Editor was successfully added."
    end
  end

  def destroy
    request = CollabRequest.find(params[:id])

    respond_to do |format|
      if request.destroy
        format.html { redirect_to user_notifications_path, notice: 'Collab request declined' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: request.errors, status: :unprocessable_entity }
      end
    end  
  end
end