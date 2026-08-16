require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "sign in page renders" do
    get new_session_url
    assert_response :success
  end

  test "signs in with valid credentials" do
    assert_difference -> { Session.count }, 1 do
      post session_url, params: { email_address: "user@example.com", password: "password" }
    end
    assert_redirected_to root_url
    assert cookies[:session_id].present?
  end

  test "rejects invalid credentials" do
    assert_no_difference -> { Session.count } do
      post session_url, params: { email_address: "user@example.com", password: "salah" }
    end
    assert_redirected_to new_session_url
  end

  test "signs out" do
    sign_in users(:user)
    assert_difference -> { Session.count }, -1 do
      delete session_url
    end
    assert_redirected_to new_session_url
    assert cookies[:session_id].blank?
  end
end
