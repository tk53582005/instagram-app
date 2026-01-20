# Preview all emails at http://localhost:3000/rails/mailers/mention_mailer
class MentionMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/mention_mailer/mention_notification
  def mention_notification
    MentionMailer.mention_notification
  end
end
