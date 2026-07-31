require "test_helper"

class TransactionPolicyTest < ActiveSupport::TestCase
  setup do
    @user1 = users(:one) || User.create!(email_address: "user1@example.com", password: "password")
    @user2 = User.create!(email_address: "user2@example.com", password: "password")
    
    @user1.transactions.destroy_all
    @user2.transactions.destroy_all

    @transaction1 = @user1.transactions.create!(purpose: "Lunch", total: 100000)
    @transaction2 = @user2.transactions.create!(purpose: "Dinner", total: 200000)
  end

  test "owner can access actions" do
    policy = TransactionPolicy.new(@user1, @transaction1)
    assert policy.show?
    assert policy.update?
    assert policy.destroy?
  end

  test "non-owner cannot access member actions" do
    policy = TransactionPolicy.new(@user2, @transaction1)
    refute policy.show?
    refute policy.update?
    refute policy.destroy?
  end

  test "scope returns only owned records" do
    scope = TransactionPolicy::Scope.new(@user1, Transaction.all).resolve
    assert_includes scope, @transaction1
    refute_includes scope, @transaction2
  end
end
