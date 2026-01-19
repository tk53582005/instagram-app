class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @like = @post.likes.build(user: current_user)
    if @like.save
      respond_to do |format|
        format.html { redirect_to posts_path }
        format.js
      end
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)
    @like.destroy if @like
    respond_to do |format|
      format.html { redirect_to posts_path }
      format.js
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end