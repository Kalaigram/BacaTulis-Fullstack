require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated user is redirected to sign in" do
    get dashboard_url
    assert_redirected_to new_session_url
  end

  test "user sees their own stats" do
    sign_in users(:user)
    get dashboard_url
    assert_response :success
    assert_select "h1", text: "Dashboard"
    assert_select "span", text: "Total Post"
  end

  test "admin sees user count" do
    sign_in users(:admin)
    get dashboard_url
    assert_response :success
    assert_select "span", text: "Total Pengguna"
  end
end
