class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :followings, :followers]

  def show
    @posts = @user.posts
                  .order(created_at: :desc)
                  .includes(:images_attachments, :likes, :comments)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to profile_path(@user.username), notice: 'プロフィールを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def followings
    @users = @user.followings.includes(:profile_image_attachment)
  end

  def followers
    @users = @user.followers.includes(:profile_image_attachment)
  end

  private

  def set_user
    @user = User.find_by(username: params[:username])
    redirect_to root_path, alert: 'ユーザーが見つかりません' unless @user
  end

  def profile_params
    params.require(:user).permit(:name, :profile_image)
  end
end