require "test_helper"

class PasswordChangesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) || User.take
  end

  test "should require authentication for edit" do
    get edit_password_change_path
    assert_redirected_to new_session_path
  end

  test "should require authentication for update" do
    patch password_change_path, params: { user: { current_password: "password", password: "new_password", password_confirmation: "new_password" } }
    assert_redirected_to new_session_path
  end

  test "should get edit when authenticated" do
    sign_in_as(@user)
    get edit_password_change_path
    assert_response :success
  end

  test "should fail to update if current password is blank" do
    sign_in_as(@user)
    patch password_change_path, params: { user: { current_password: "", password: "new_password", password_confirmation: "new_password" } }
    assert_response :unprocessable_entity
    
    expected_error = @user.class.human_attribute_name(:current_password) + " " + I18n.t("errors.messages.blank")
    assert_match expected_error, response.body
  end

  test "should fail to update if current password is incorrect" do
    sign_in_as(@user)
    patch password_change_path, params: { user: { current_password: "wrong_password", password: "new_password", password_confirmation: "new_password" } }
    assert_response :unprocessable_entity
    
    expected_error = @user.class.human_attribute_name(:current_password) + " " + I18n.t("password_changes.errors.incorrect")
    assert_match expected_error, response.body
  end

  test "should fail to update if new password is blank" do
    sign_in_as(@user)
    patch password_change_path, params: { user: { current_password: "password", password: "", password_confirmation: "" } }
    assert_response :unprocessable_entity
    
    expected_error = @user.class.human_attribute_name(:password) + " " + I18n.t("errors.messages.blank")
    assert_match expected_error, response.body
  end

  test "should fail to update if password confirmation does not match" do
    sign_in_as(@user)
    patch password_change_path, params: { user: { current_password: "password", password: "new_password", password_confirmation: "different" } }
    assert_response :unprocessable_entity
    
    expected_error = I18n.t("errors.messages.confirmation", attribute: @user.class.human_attribute_name(:password))
    assert_match expected_error, response.body
  end

  test "should successfully update password with valid parameters" do
    sign_in_as(@user)
    patch password_change_path, params: { user: { current_password: "password", password: "new_password", password_confirmation: "new_password" } }
    assert_redirected_to root_path
    follow_redirect!
    assert_match I18n.t("password_changes.update.success"), response.body

    # Verify password was updated by trying to authenticate
    assert @user.reload.authenticate("new_password")
  end
end
