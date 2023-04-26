require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:percentage_discount).
        is_less_than_or_equal_to(99).is_greater_than_or_equal_to(1)}
    it { should validate_numericality_of(:quantity_threshold)}
  end
end