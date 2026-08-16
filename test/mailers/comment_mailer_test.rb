require "test_helper"

class CommentMailerTest < ActionMailer::TestCase
  test "notification is sent to the post author" do
    comment = comments(:admin_comment)
    email = CommentMailer.notification(comment)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "user@example.com" ], email.to
    assert_match "Post milik user", email.subject
    assert_match "Komentar dari admin untuk post user.", email.body.encoded
  end
end
