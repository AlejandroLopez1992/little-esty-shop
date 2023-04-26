class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates :name, presence: true
  validates :percentage_discount, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 99}
  validates :quantity_threshold, numericality: { only_integer: true }
end