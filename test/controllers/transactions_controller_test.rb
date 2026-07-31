require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) || User.take
    # Ensure there are some transactions for sorting tests
    @user.transactions.destroy_all
    @t1 = @user.transactions.create!(purpose: "Lunch", total: 100000, created_at: 2.days.ago)
    @t2 = @user.transactions.create!(purpose: "Dinner", total: 250000, created_at: 1.day.ago)
    @t3 = @user.transactions.create!(purpose: "Coffee", total: 50000, created_at: Time.current)
  end

  test "should require authentication for index" do
    get transactions_path
    assert_redirected_to new_session_path
  end

  test "should get index with default sort (created_at desc)" do
    sign_in_as(@user)
    get transactions_path
    assert_response :success

    # Default sort is created_at desc, so order should be: t3, t2, t1
    transactions = assigns(:transactions).to_a
    assert_equal [@t3.id, @t2.id, @t1.id], transactions.map(&:id)
  end

  test "should sort by created_at asc" do
    sign_in_as(@user)
    get transactions_path, params: { sort: "created_at", direction: "asc" }
    assert_response :success

    # Order should be: t1, t2, t3
    transactions = assigns(:transactions).to_a
    assert_equal [@t1.id, @t2.id, @t3.id], transactions.map(&:id)
  end

  test "should sort by total desc" do
    sign_in_as(@user)
    get transactions_path, params: { sort: "total", direction: "desc" }
    assert_response :success

    # Order by total desc should be: t2 (250k), t1 (100k), t3 (50k)
    transactions = assigns(:transactions).to_a
    assert_equal [@t2.id, @t1.id, @t3.id], transactions.map(&:id)
  end

  test "should sort by total asc" do
    sign_in_as(@user)
    get transactions_path, params: { sort: "total", direction: "asc" }
    assert_response :success

    # Order by total asc should be: t3 (50k), t1 (100k), t2 (250k)
    transactions = assigns(:transactions).to_a
    assert_equal [@t3.id, @t1.id, @t2.id], transactions.map(&:id)
  end

  test "should paginate transactions based on items param" do
    sign_in_as(@user)

    # Request with items=2, should only return the first 2 transactions (t3, t2)
    get transactions_path, params: { items: 2 }
    assert_response :success

    transactions = assigns(:transactions).to_a
    assert_equal 2, transactions.size
    assert_equal [@t3.id, @t2.id], transactions.map(&:id)

    # Request page 2 with items=2, should return the remaining transaction (t1)
    get transactions_path, params: { items: 2, page: 2 }
    assert_response :success

    transactions = assigns(:transactions).to_a
    assert_equal 1, transactions.size
    assert_equal [@t1.id], transactions.map(&:id)
  end
end
