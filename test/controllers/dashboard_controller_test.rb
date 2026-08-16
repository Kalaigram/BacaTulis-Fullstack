require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated user is redirected to sign in" do
    get root_url
    assert_redirected_to new_session_url
  end

  test "user sees their own stats" do
    sign_in users(:user)
    get root_url
    assert_response :success
    assert_select "h1", text: "Dashboard"
    assert_select "span", text: "Total Post"
  end

  test "admin sees user count" do
    sign_in users(:admin)
    get root_url
    assert_response :success
    assert_select "span", text: "Total Pengguna"
  end
end
