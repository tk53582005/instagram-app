class MentionNotificationJob < ApplicationJob
  queue_as :mailers

  def perform(comment_id)
    comment = Comment.find(comment_id)
    mentioned_usernames = comment.mentioned_usernames
    
    mentioned_usernames.each do |username|
      user = User.find_by(username: username)
      next unless user && user != comment.user # 自分へのメンションは通知しない
      
      # メール送信
      MentionMailer.mention_notification(user, comment).deliver_now
    end
  end
end