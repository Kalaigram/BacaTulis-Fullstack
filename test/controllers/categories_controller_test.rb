require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated user is redirected to sign in" do
    get categories_url
    assert_redirected_to new_session_url
  end

  test "regular user cannot access categories" do
    sign_in users(:user)
    get categories_url
    assert_redirected_to root_url
  end

  test "admin can list categories" do
    sign_in users(:admin)
    get categories_url
    assert_response :success
    assert_select "table"
  end

  test "admin can create a category" do
    sign_in users(:admin)
    assert_difference -> { Category.count }, 1 do
      post categories_url, params: { category: { name: "Testing" } }
    end
    assert_redirected_to categories_url
    assert_equal "testing", Category.last.slug
  end

  test "admin can update a category" do
    sign_in users(:admin)
    patch category_url(categories(:ruby)), params: { category: { name: "Bahasa Ruby" } }
    assert_redirected_to categories_url
    assert_equal "Bahasa Ruby", categories(:ruby).reload.name
  end

  test "admin can destroy a category and nullify posts" do
    sign_in users(:admin)
    assert_difference -> { Category.count }, -1 do
      delete category_url(categories(:rails))
    end
    assert_redirected_to categories_url
    assert_nil posts(:user_post).reload.category
  end
end
