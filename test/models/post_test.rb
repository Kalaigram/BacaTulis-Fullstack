require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "valid with title, body, and user" do
    post = Post.new(title: "Judul", body: "Isi", user: users(:user))
    assert post.valid?
  end

  test "title is required" do
    post = Post.new(title: "", body: "Isi", user: users(:user))
    assert_not post.valid?
  end

  test "body is required" do
    post = Post.new(title: "Judul", body: "", user: users(:user))
    assert_not post.valid?
  end

  test "belongs to a user" do
    assert_equal users(:user), posts(:user_post).user
  end
end
