class TransactionsController < ApplicationController
  include Pagy::Method

  rescue_from Pagy::RangeError, with: :overflow_page

  before_action :set_transaction, only: %i[show edit update destroy]

  def index
    sort_column = %w[total created_at].include?(params[:sort]) ? params[:sort] : "created_at"
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"

    # Validate items per page to prevent abnormally large request sizes
    allowed_items = [5, 10, 20, 50, 100]
    items_per_page = allowed_items.include?(params[:items].to_i) ? params[:items].to_i : (Pagy::DEFAULT[:items] || 10)

    transactions_scope = policy_scope(Current.user.transactions)
    
    # Calculate separate totals for income, expense, and balance
    @total_income = transactions_scope.where(income: true).sum(:total)
    @total_expense = transactions_scope.where(income: false).sum(:total)
    @balance = @total_income - @total_expense

    @pagy, @transactions = pagy(
      transactions_scope.order(sort_column => sort_direction),
      limit: items_per_page
    )
  end

  def show
  end

  def new
    @transaction = Current.user.transactions.build
    authorize @transaction
  end

  def edit
  end

  def create
    @transaction = Current.user.transactions.build(transaction_params)
    authorize @transaction

    if @transaction.save
      redirect_to transactions_path, notice: t("transactions.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to transactions_path, notice: t("transactions.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_path, notice: t("transactions.destroyed")
  end

  private

  def set_transaction
    @transaction = Current.user.transactions.find(params[:id])
    authorize @transaction
  end

  def transaction_params
    params.require(:transaction).permit(:purpose, :total, :income)
  end


  def overflow_page(e)
    redirect_to e.pagy.page_url(:last)
  end
end
