class Item < ApplicationRecord
  self.primary_key = :id
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items
end