require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated user is redirected to sign in" do
    get users_url
    assert_redirected_to new_session_url
  end

  test "regular user cannot access users index" do
    sign_in users(:user)
    get users_url
    assert_redirected_to root_url
  end

  test "admin can list users" do
    sign_in users(:admin)
    get users_url
    assert_response :success
    assert_select "table"
  end

  test "admin can change a user role" do
    sign_in users(:admin)
    patch user_url(users(:user)), params: { user: { role: "admin" } }
    assert_redirected_to users_url
    assert users(:user).reload.admin?
  end

  test "admin cannot change their own role" do
    sign_in users(:admin)
    patch user_url(users(:admin)), params: { user: { role: "user" } }
    assert_redirected_to users_url
    assert users(:admin).reload.admin?
  end

  test "admin can change a user role back" do
    sign_in users(:admin)
    users(:user).update!(role: :admin)
    patch user_url(users(:user)), params: { user: { role: "user" } }
    assert_redirected_to users_url
    assert users(:user).reload.user?
  end

  test "admin can delete a user" do
    sign_in users(:admin)
    assert_difference -> { User.count }, -1 do
      delete user_url(users(:user))
    end
    assert_redirected_to users_url
  end

  test "admin cannot delete themselves" do
    sign_in users(:admin)
    assert_no_difference -> { User.count } do
      delete user_url(users(:admin))
    end
    assert_redirected_to users_url
  end
end
