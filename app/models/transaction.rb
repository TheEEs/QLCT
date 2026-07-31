class Transaction < ApplicationRecord
  belongs_to :user

  validates :purpose, presence: true, length: { maximum: 255 }
  validates :total, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
