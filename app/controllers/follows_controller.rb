class FollowsController < ApplicationController
  def create
    follower = User.find(params[:follower])
    followee = User.find(params[:followee])

    follow = Follow.new(follower: follower, followed: followee)

    notification = Notification.new(
      message: "<a href='/users/#{follower.id}'>#{follower.username ? follower.username : follower.email}</a> just followed you!",
      sender_id: follower.id,
      recipient_id: followee.id,
      read: false
    )

    respond_to do |format|
      if follow.save
        notification.save
        format.html { redirect_to user_account_path(followee) }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: follow.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    follower = params[:follower]
    followee = params[:followee]
    
    follow = Follow.where(follower_id: follower, followed_id: followee).first
    
    respond_to do |format|
      if follow.destroy
        format.html { redirect_to user_account_path(followee) }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: follow.errors, status: :unprocessable_entity }
      end
    end
  end
end
