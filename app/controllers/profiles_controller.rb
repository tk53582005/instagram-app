class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find_by(username: params[:username]) || current_user
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

  private

  def profile_params
    params.require(:user).permit(:name, :profile_image)
  end
end