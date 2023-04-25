class InvoiceItem < ApplicationRecord
  self.primary_key = :id
  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :invoice

  enum status: ['pending', 'packaged', 'shipped']

  def format_unit_price
    (unit_price / 100.0).round(2).to_s
  end

  def items_name
    item.name
  end

  def applied_bulk_discount
    BulkDiscount.joins(merchant: [items: :invoice_items])
    .select("bulk_discounts.*")
    .where("items.merchant_id = bulk_discounts.merchant_id AND 
     invoice_items.quantity >= bulk_discounts.quantity_threshold
     AND invoice_items.id = ?", self.id)
    .order("bulk_discounts.quantity_threshold DESC")
    .first
  end
end