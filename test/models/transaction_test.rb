require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  setup do
    @user = users(:one) || User.take
  end

  test "should default income to false" do
    transaction = @user.transactions.create!(purpose: "Lunch", total: 100000)
    assert_not transaction.income?
  end

  test "should be able to create an income transaction" do
    transaction = @user.transactions.create!(purpose: "Salary", total: 50000000, income: true)
    assert transaction.income?
  end

  test "should require purpose" do
    transaction = @user.transactions.build(total: 100000)
    assert_not transaction.valid?
    assert_includes transaction.errors[:purpose], "không được để trống"
  end

  test "should require positive total" do
    transaction = @user.transactions.build(purpose: "Coffee", total: 0)
    assert_not transaction.valid?
    assert_includes transaction.errors[:total], "phải lớn hơn 0"
  end
end
