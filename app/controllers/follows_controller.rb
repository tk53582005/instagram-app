class FollowsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @user = User.find(params[:following_id])
    current_user.follow(@user)
    
    respond_to do |format|
      format.html { redirect_to profile_path(@user.username) }
      format.js
    end
  end
  
  def destroy
    @follow = Follow.find(params[:id])
    @user = @follow.following
    @follow.destroy
    
    respond_to do |format|
      format.html { redirect_to profile_path(@user.username) }
      format.js
    end
  end
end