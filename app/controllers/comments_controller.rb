class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      # メンション通知を非同期で送信
      MentionNotificationJob.perform_later(@comment.id) if @comment.mentioned_usernames.any?

      respond_to do |format|
        format.html { redirect_to post_path(@post) }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to post_path(@post), alert: "コメントの投稿に失敗しました" }
        format.js { render :error }
      end
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])

    if @comment.user == current_user
      @comment.destroy

      respond_to do |format|
        format.html { redirect_to post_path(@post), notice: "コメントを削除しました" }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to post_path(@post), alert: "削除できません" }
        format.js { render :error }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
