require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated user is redirected to sign in" do
    get posts_url
    assert_redirected_to new_session_url
  end

  test "user sees only their own posts" do
    sign_in users(:user)
    get posts_url
    assert_response :success
    assert_select "h2", text: "Post milik user"
    assert_select "h2", text: "Post milik admin", count: 0
  end

  test "admin sees all posts" do
    sign_in users(:admin)
    get posts_url
    assert_response :success
    assert_select "h2", text: "Post milik user"
    assert_select "h2", text: "Post milik admin"
  end

  test "user cannot show another user's post" do
    sign_in users(:user)
    get post_url(posts(:admin_post))
    assert_response :not_found
  end

  test "admin can show any post" do
    sign_in users(:admin)
    get post_url(posts(:user_post))
    assert_response :success
  end

  test "user can create their own post" do
    sign_in users(:user)
    assert_difference -> { Post.count }, 1 do
      post posts_url, params: { post: { title: "Post baru", body: "Isi post baru" } }
    end
    assert_redirected_to post_path(Post.last)
    assert_equal users(:user), Post.last.user
    assert_predicate Post.last, :published?
  end

  test "user can create a draft post" do
    sign_in users(:user)
    assert_difference -> { Post.count }, 1 do
      post posts_url, params: { post: { title: "Draft baru", body: "Isi draft", status: "draft" } }
    end
    assert_predicate Post.last, :draft?
  end

  test "user can filter posts by status" do
    sign_in users(:user)
    get posts_url(status: "draft")
    assert_response :success
    assert_select "h2", text: "Draft rahasia user"
    assert_select "h2", text: "Post milik user", count: 0
  end

  test "user can search posts" do
    sign_in users(:user)
    get posts_url(q: "rahasia")
    assert_response :success
    assert_select "h2", text: "Draft rahasia user"
    assert_select "h2", text: "Post milik user", count: 0
  end

  test "user can filter posts by category" do
    sign_in users(:user)
    get posts_url(category_id: categories(:rails).id)
    assert_response :success
    assert_select "h2", text: "Post milik user"
    assert_select "h2", text: "Draft rahasia user", count: 0
  end

  test "user can create a post with a category" do
    sign_in users(:user)
    post posts_url, params: { post: { title: "Post berkategori", body: "Isi", category_id: categories(:ruby).id } }
    assert_redirected_to post_path(Post.last)
    assert_equal categories(:ruby), Post.last.category
  end

  test "user can edit their own post" do
    sign_in users(:user)
    patch post_url(posts(:user_post)), params: { post: { title: "Judul diubah" } }
    assert_redirected_to post_path(posts(:user_post))
    assert_equal "Judul diubah", posts(:user_post).reload.title
  end

  test "user cannot edit another user's post" do
    sign_in users(:user)
    patch post_url(posts(:admin_post)), params: { post: { title: "Hack" } }
    assert_response :not_found
  end

  test "admin can edit any post" do
    sign_in users(:admin)
    patch post_url(posts(:user_post)), params: { post: { title: "Diedit admin" } }
    assert_redirected_to post_path(posts(:user_post))
    assert_equal "Diedit admin", posts(:user_post).reload.title
  end

  test "user can destroy their own post" do
    sign_in users(:user)
    assert_difference -> { Post.count }, -1 do
      delete post_url(posts(:user_post))
    end
    assert_redirected_to posts_url
  end

  test "user cannot destroy another user's post" do
    sign_in users(:user)
    assert_no_difference -> { Post.count } do
      delete post_url(posts(:admin_post))
    end
    assert_response :not_found
  end
end
