class Transaction < ApplicationRecord
  self.primary_key = :id
  belongs_to :invoice

  enum result: ['failed', 'success']
end