class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :destroy]

  def index
    @posts = Post.includes(:user).recent
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: '投稿しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    if @post.user == current_user
      @post.destroy
      redirect_to posts_path, notice: '投稿を削除しました'
    else
      redirect_to posts_path, alert: '削除できません'
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, images: [])
  end
end