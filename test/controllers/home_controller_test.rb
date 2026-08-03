require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) || User.take
    @user.transactions.destroy_all

    # 350,000 ₫ total expenses
    @user.transactions.create!(purpose: "Lunch", total: 100000, income: false)
    @user.transactions.create!(purpose: "Shopping", total: 250000, income: false)

    # 5,000,000 ₫ total income
    @user.transactions.create!(purpose: "Salary bonus", total: 5000000, income: true)
  end

  test "should get index" do
    get root_path
    assert_response :success
  end

  test "should calculate correct totals for authenticated user" do
    sign_in_as(@user)
    get root_path
    assert_response :success

    assert_equal 5000000, assigns(:total_income)
    assert_equal 350000, assigns(:total_expenses)
  end
end
