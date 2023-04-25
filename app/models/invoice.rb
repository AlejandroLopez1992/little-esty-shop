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
    require 'pry'; binding.pry
    invoice_items_total_revenue = selected_invoice_items.map do |invoice_item|
      invoice_item.quantity * invoice_item.unit_price * (1 - invoice_item.percentage_discount.to_f / 100)
    end

    (invoice_items_total_revenue.sum/100).round(2).to_s
    # x = InvoiceItem.find_by_sql("SELECT invoice_items.*, bulk_discounts.*
    # FROM invoice_items
    # LEFT JOIN items ON invoice_items.item_id = items.id
    # LEFT JOIN bulk_discounts ON items.merchant_id = bulk_discounts.merchant_id AND invoice_items.quantity >= bulk_discounts.quantity_threshold
    # LEFT JOIN (SELECT invoice_items.id as invoice_item_id, MAX(bulk_discounts.quantity_threshold) as applied_threshold
    # FROM invoice_items
    # LEFT JOIN items ON invoice_items.item_id = items.id
    # LEFT JOIN bulk_discounts ON items.merchant_id = bulk_discounts.merchant_id AND invoice_items.quantity >= bulk_discounts.quantity_threshold
    # GROUP BY invoice_items.id) max_quantity_threshold ON bulk_discounts.quantity_threshold = max_quantity_threshold.applied_threshold AND invoice_items.id = max_quantity_threshold.invoice_item_id
    # WHERE invoice_items.invoice_id = #{self.id}")

    
    # x = InvoiceItem.from("invoice_items").joins("LEFT JOIN items ON invoice_items.item_id = items.id")
    # .joins("LEFT JOIN bulk_discounts ON items.merchant_id = bulk_discounts.merchant_id AND invoice_items.quantity >= bulk_discounts.quantity_threshold")
    # .where("invoice_items.invoice_id = ?", self.id)
    # .select("invoice_items.*, MAX(bulk_discounts.quantity_threshold) as bullshit")
    # .group("invoice_items.id")
    # .select("")

    
    # x = InvoiceItem.left_outer_joins(item: [merchant: :bulk_discounts])
    # .select("invoice_items.*, bulk_discounts.quantity_threshold")
    # .where("invoice_items.quantity >= bulk_discounts.quantity_threshold AND items.merchant_id = bulk_discounts.merchant_id AND invoice_items.invoice_id = ?", self.id)
    # .group(:id)
    # .max("bulk_discounts.quantity_threshold")
    # .sum("(invoice_items.unit_price * quantity) * (100 - bulk_discounts.quantity_threshold))")
  end
end