class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :destroy]

  def index
    # フォローしているユーザーのIDを取得
    following_ids = current_user.followings.pluck(:id)
    
    if following_ids.any?
      # フォローしているユーザーの投稿
      following_posts = Post.where(user_id: following_ids)
      
      # 24時間以内の人気投稿（いいね数上位5件）
      trending_posts = Post.where('posts.created_at >= ?', 24.hours.ago)
                          .left_joins(:likes)
                          .group('posts.id')
                          .order('COUNT(likes.id) DESC')
                          .limit(5)
      
      # 重複を除いて結合し、作成日時でソート
      post_ids = (following_posts.pluck(:id) + trending_posts.pluck(:id)).uniq
      @posts = Post.where(id: post_ids)
                   .includes(:user, :images_attachments, :likes, :comments)
                   .order(created_at: :desc)
    else
      # フォローしているユーザーがいない場合は全投稿を表示
      @posts = Post.includes(:user, :images_attachments, :likes, :comments)
                   .order(created_at: :desc)
    end
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