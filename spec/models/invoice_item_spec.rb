require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_many(:transactions).through(:invoice) }
  end

  describe 'Instance Methods' do
    let!(:merchant) { create(:merchant) }
    let!(:merchant_1) { create(:merchant) }

    let!(:item_1) { create(:item, merchant_id: merchant.id, name: "Grandaddy Purple") }
    let!(:item_2) { create(:item, merchant_id: merchant.id, name: "Girl Scout Cookies") }
    let!(:item_3) { create(:item, merchant_id: merchant.id, name: "OG Kush") }
    let!(:item_4) { create(:item, merchant_id: merchant.id) }
    let!(:item_5) { create(:item, merchant_id: merchant.id) }
    let!(:item_9) { create(:item, merchant_id: merchant_1.id) }

    let!(:customer_1) { create(:customer, first_name: 'Branden', last_name: 'Smith') }
    let!(:customer_2) { create(:customer, first_name: 'Reilly', last_name: 'Robertson') }
    let!(:customer_3) { create(:customer, first_name: 'Grace', last_name: 'Chavez') }
    let!(:customer_4) { create(:customer, first_name: 'Logan', last_name: 'Nguyen') }
    let!(:customer_5) { create(:customer, first_name: 'Brandon', last_name: 'Popular') }
    let!(:customer_6) { create(:customer, first_name: 'Caroline', last_name: 'Rasmussen') }

    static_time_1 = Time.zone.parse('2023-04-13 00:50:37')
    static_time_2 = Time.zone.parse('2023-04-12 00:50:37')
    static_time_3 = Time.zone.parse('2023-04-15 00:50:37')

    let!(:invoice_1) { create(:invoice, customer_id: customer_1.id, created_at: static_time_1) }
    let!(:invoice_2) { create(:invoice, customer_id: customer_2.id, created_at: static_time_2) }
    let!(:invoice_3) { create(:invoice, customer_id: customer_3.id, created_at: static_time_3) }
    let!(:invoice_4) { create(:invoice, customer_id: customer_4.id) }
    let!(:invoice_5) { create(:invoice, customer_id: customer_5.id) }
    let!(:invoice_7) { create(:invoice, customer_id: customer_6.id) }

    let!(:bulk_discount_1) { create(:bulk_discount, merchant_id: merchant.id, name: "Green Special", percentage_discount: 20, quantity_threshold: 5) }
    let!(:bulk_discount_2) { create(:bulk_discount, merchant_id: merchant.id, name: "Red Special", percentage_discount: 35, quantity_threshold: 10) }
    let!(:bulk_discount_3) { create(:bulk_discount, merchant_id: merchant.id, name: "Yellow Special", percentage_discount: 50, quantity_threshold: 15) }
    let!(:bulk_discount_4) { create(:bulk_discount, merchant_id: merchant_1.id, name: "Blue Special", percentage_discount: 25, quantity_threshold: 5) }

    let!(:invoice_item_1) { create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 2, unit_price: 40001) }
    let!(:invoice_item_2) { create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id, status: 2) }
    let!(:invoice_item_3) { create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 2) }
    let!(:invoice_item_4) { create(:invoice_item, item_id: item_4.id, invoice_id: invoice_4.id, status: 0, unit_price: 5000, quantity: 10) }
    let!(:invoice_item_5) { create(:invoice_item, item_id: item_5.id, invoice_id: invoice_5.id, status: 0, unit_price: 10000, quantity: 2) }
    let!(:invoice_item_7) { create(:invoice_item, item_id: item_9.id, invoice_id: invoice_7.id, status: 1, unit_price: 12345) }
    
    it '#format_unit_price' do
      expect(invoice_item_1.format_unit_price).to eq("400.01")
      expect(invoice_item_7.format_unit_price).to eq("123.45")
    end

    it '#items_name' do
        expect(invoice_item_1.items_name).to eq("Grandaddy Purple")
        expect(invoice_item_2.items_name).to eq("Girl Scout Cookies")
        expect(invoice_item_3.items_name).to eq("OG Kush")
    end

    describe '#applied_bulk_discount' do
      it 'retreives the bulk discount applied to this invoice' do
        expect(invoice_item_4.applied_bulk_discount).to eq(bulk_discount_2)
      end

      it 'if no bulk discount has been applied returns nil' do
        expect(invoice_item_5.applied_bulk_discount).to eq(nil)
      end
    end
  end
end