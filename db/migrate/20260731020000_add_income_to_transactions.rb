class AddIncomeToTransactions < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :income, :boolean, default: false, null: false
  end
end
