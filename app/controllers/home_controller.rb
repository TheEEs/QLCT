class HomeController < ApplicationController
  allow_unauthenticated_access
  def index
    if authenticated?
      @transactions = Current.user.transactions.order(created_at: :desc).limit(5)
      @total_expenses = Current.user.transactions.sum(:total)
    end
  end
end
