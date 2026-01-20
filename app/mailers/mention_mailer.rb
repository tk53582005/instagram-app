class MentionMailer < ApplicationMailer
  default from: 'notifications@instagram-app.com'

  def mention_notification(user, comment)
    @user = user
    @comment = comment
    @post = comment.post
    @commenter = comment.user

    mail(
      to: user.email,
      subject: "#{@commenter.username}さんがあなたをメンションしました"
    )
  end
end