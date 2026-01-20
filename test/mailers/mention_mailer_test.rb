require "test_helper"

class MentionMailerTest < ActionMailer::TestCase
  test "mention_notification" do
    mail = MentionMailer.mention_notification
    assert_equal "Mention notification", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
