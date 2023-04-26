class Invoice < ApplicationRecord
  self.primary_key = :id
  validates :status, presence: true
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  has_many :merchants, through: :items

  enum status: ['cancelled', 'in progress', 'completed']

  def self.invoice_items_not_shipped
    select('invoices.*').joins(:invoice_items).where(invoice_items: {status: ['pending', 'packaged']})
  end

  def format_time_stamp
    created_at.strftime('%A, %B %e, %Y')
  end

  def customer_full_name
  "#{customer.first_name} #{customer.last_name}"
  end

  def total_revenue
    invoice_items.sum("(quantity * unit_price )/ 100.0").round(2).to_s
  end

  def bulk_discount_total_revenue
    selected_invoice_items = InvoiceItem.find_by_sql("SELECT * FROM (SELECT ROW_NUMBER () OVER(PARTITION BY invoice_items.id ORDER BY bulk_discounts.quantity_threshold DESC) AS row_number,
    invoice_items.*, bulk_discounts.*
    FROM invoice_items
    LEFT JOIN items ON invoice_items.item_id = items.id
    LEFT JOIN bulk_discounts ON items.merchant_id = bulk_discounts.merchant_id AND invoice_items.quantity >= bulk_discounts.quantity_threshold
    WHERE invoice_items.invoice_id = #{self.id}) AS joined_table WHERE joined_table.row_number = 1")

    invoice_items_total_revenue = selected_invoice_items.map do |invoice_item|
      invoice_item.quantity * invoice_item.unit_price * (1 - invoice_item.percentage_discount.to_f / 100)
    end

    (invoice_items_total_revenue.sum/100).round(2).to_s
  end
end