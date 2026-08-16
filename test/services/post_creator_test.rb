require "test_helper"

class PostCreatorTest < ActiveSupport::TestCase
  test "creates a post for the given user" do
    assert_difference -> { users(:user).posts.count }, 1 do
      PostCreator.call(users(:user), title: "Judul baru", body: "Isi post", status: "published")
    end
  end

  test "rejects a post without a title" do
    service = PostCreator.call(users(:user), title: "", body: "Isi post")
    refute service.success?
  end
end
