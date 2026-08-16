require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "sign up page renders" do
    get new_registration_url
    assert_response :success
  end

  test "user can sign up and is signed in" do
    assert_difference -> { User.count }, 1 do
      post registration_url, params: { user: { name: "Pengguna Baru", email_address: "baru@example.com", password: "rahasia123", password_confirmation: "rahasia123" } }
    end
    assert_redirected_to root_url
    assert User.find_by(email_address: "baru@example.com").user?
    get root_url
    assert_response :success
  end

  test "sign up with mismatched password re-renders" do
    assert_no_difference -> { User.count } do
      post registration_url, params: { user: { name: "Pengguna Baru", email_address: "baru@example.com", password: "rahasia123", password_confirmation: "lain" } }
    end
    assert_response :unprocessable_entity
  end

  test "sign up with invalid email re-renders" do
    assert_no_difference -> { User.count } do
      post registration_url, params: { user: { name: "Pengguna Baru", email_address: "bukan-email", password: "rahasia123", password_confirmation: "rahasia123" } }
    end
    assert_response :unprocessable_entity
  end
end
