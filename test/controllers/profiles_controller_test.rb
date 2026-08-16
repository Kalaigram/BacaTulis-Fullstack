require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated user is redirected to sign in" do
    get profile_url
    assert_redirected_to new_session_url
  end

  test "user sees their profile" do
    sign_in users(:user)
    get profile_url
    assert_response :success
    assert_select "h1", text: "Profil"
    assert_select "p", /user@example\.com/
  end

  test "user can update name and email" do
    sign_in users(:user)
    patch profile_url, params: { user: { name: "Nama Baru", email_address: "baru@example.com", password: "", password_confirmation: "" } }
    assert_redirected_to profile_url
    users(:user).reload
    assert_equal "Nama Baru", users(:user).name
    assert_equal "baru@example.com", users(:user).email_address
  end

  test "user can change password" do
    sign_in users(:user)
    patch profile_url, params: { user: { name: "", email_address: "user@example.com", password: "rahasia123", password_confirmation: "rahasia123" } }
    assert_redirected_to profile_url
    assert users(:user).reload.authenticate("rahasia123")
  end

  test "blank password does not clear current password" do
    sign_in users(:user)
    patch profile_url, params: { user: { name: "", email_address: "user@example.com", password: "", password_confirmation: "" } }
    assert_redirected_to profile_url
    assert users(:user).reload.authenticate("password")
  end
end
