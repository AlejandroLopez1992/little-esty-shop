require 'rails_helper'

RSpec.describe 'Merchant/invoice show page', type: :feature do
let!(:merchant) { create(:merchant) }
let!(:merchant_1) { create(:merchant) }

let!(:item_1) { create(:item, merchant_id: merchant.id) }
let!(:item_2) { create(:item, merchant_id: merchant.id) }
let!(:item_3) { create(:item, merchant_id: merchant.id) }
let!(:item_4) { create(:item, merchant_id: merchant.id) }
let!(:item_5) { create(:item, merchant_id: merchant.id) }
let!(:item_6) { create(:item, merchant_id: merchant.id) }
let!(:item_7) { create(:item, merchant_id: merchant.id) }
let!(:item_8) { create(:item, merchant_id: merchant.id) }
let!(:item_9) { create(:item, merchant_id: merchant_1.id) }

let!(:customer_1) { create(:customer, first_name: 'Branden', last_name: 'Smith') }
let!(:customer_2) { create(:customer, first_name: 'Reilly', last_name: 'Robertson') }
let!(:customer_3) { create(:customer, first_name: 'Grace', last_name: 'Chavez') }
let!(:customer_4) { create(:customer, first_name: 'Logan', last_name: 'Nguyen') }
let!(:customer_5) { create(:customer, first_name: 'Brandon', last_name: 'Popular') }
let!(:customer_6) { create(:customer, first_name: 'Caroline', last_name: 'Rasmussen') }
let!(:customer_8) { create(:customer, first_name: 'Billy', last_name: 'Joel') }

static_time_1 = Time.zone.parse('2023-04-13 00:50:37')
static_time_2 = Time.zone.parse('2023-04-12 00:50:37')
static_time_3 = Time.zone.parse('2023-04-15 00:50:37')

let!(:invoice_1) { create(:invoice, customer_id: customer_1.id, created_at: static_time_1) }
let!(:invoice_2) { create(:invoice, customer_id: customer_2.id, created_at: static_time_2) }
let!(:invoice_3) { create(:invoice, customer_id: customer_3.id, created_at: static_time_3) }
let!(:invoice_4) { create(:invoice, customer_id: customer_4.id) }
let!(:invoice_5) { create(:invoice, customer_id: customer_5.id) }
let!(:invoice_6) { create(:invoice, customer_id: customer_6.id) }
let!(:invoice_7) { create(:invoice, customer_id: customer_6.id) }

let!(:bulk_discount_1) { create(:bulk_discount, merchant_id: merchant.id, name: "Green Special", percentage_discount: 20, quantity_threshold: 5) }
let!(:bulk_discount_2) { create(:bulk_discount, merchant_id: merchant.id, name: "Red Special", percentage_discount: 35, quantity_threshold: 10) }
let!(:bulk_discount_3) { create(:bulk_discount, merchant_id: merchant.id, name: "Yellow Special", percentage_discount: 50, quantity_threshold: 15) }
let!(:bulk_discount_4) { create(:bulk_discount, merchant_id: merchant_1.id, name: "Blue Special", percentage_discount: 25, quantity_threshold: 5) }

let!(:invoice_item_1) { create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 0, unit_price: 6000, quantity: 5) }
let!(:invoice_item_2) { create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id, status: 2) }
let!(:invoice_item_3) { create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 2) }
let!(:invoice_item_4) { create(:invoice_item, item_id: item_4.id, invoice_id: invoice_4.id, status: 0) }
let!(:invoice_item_5) { create(:invoice_item, item_id: item_5.id, invoice_id: invoice_5.id, status: 0) }
let!(:invoice_item_6) { create(:invoice_item, item_id: item_6.id, invoice_id: invoice_6.id, status: 2, unit_price: 999, quantity: 12) }
let!(:invoice_item_7) { create(:invoice_item, item_id: item_9.id, invoice_id: invoice_7.id, status: 1) }
let!(:invoice_item_8) { create(:invoice_item, item_id: item_9.id, invoice_id: invoice_6.id, status: 1, unit_price: 8800, quantity: 10) }
let!(:invoice_item_9) { create(:invoice_item, item_id: item_9.id, invoice_id: invoice_3.id, status: 1, unit_price: 8800, quantity: 4) }


let!(:inv_1_transaction_s) { create_list(:transaction, 10, result: 1, invoice_id: invoice_1.id) }
let!(:inv_1_transaction_f) { create_list(:transaction, 5, result: 0, invoice_id: invoice_1.id) }
let!(:inv_2_transaction_s) { create_list(:transaction, 5, result: 1, invoice_id: invoice_2.id) }
let!(:inv_3_transaction_s) { create_list(:transaction, 7, result: 1, invoice_id: invoice_3.id) }
let!(:inv_4_transaction_s) { create_list(:transaction, 3, result: 1, invoice_id: invoice_4.id) }
let!(:inv_4_transaction_f) { create_list(:transaction, 20, result: 0, invoice_id: invoice_4.id) }
let!(:inv_5_transaction_s) { create_list(:transaction, 11, result: 1, invoice_id: invoice_5.id) }
let!(:inv_6_transaction_s) { create_list(:transaction, 8, result: 1, invoice_id: invoice_6.id) }

  describe 'Information related to the invoice' do
    it 'should display the invoice id, status, and created_at date' do
      visit merchant_invoice_path(merchant, invoice_1.id)
      
      expect(page).to have_content(invoice_1.id)
      expect(page).to have_content(invoice_1.status)
      expect(page).to have_content(invoice_1.format_time_stamp)
      
      visit merchant_invoice_path(merchant, invoice_2.id)
      
      expect(page).to have_content(invoice_2.id)
      expect(page).to have_content(invoice_2.status)
      expect(page).to have_content(invoice_2.format_time_stamp)
      expect(page).to_not have_content(invoice_3.format_time_stamp)
    end

    it 'should display the first and last name of the customer associated with this invoice.' do
      visit merchant_invoice_path(merchant, invoice_2.id)
      
      expect(page).to have_content(invoice_2.customer_full_name)
      expect(invoice_2.customer.first_name).to appear_before(invoice_2.customer.last_name)
    end

    it 'should display the total revenue of items on the invoice' do
      visit merchant_invoice_path(merchant, invoice_1.id)
      
      expect(page).to have_content("Total Revenue: $300.0")
      
      visit merchant_invoice_path(merchant, invoice_6.id)
      
      expect(page).to have_content("Total Revenue: $999.88")
    end

    it 'should display the bulk_discount_total_revenue of the invoice' do
      visit merchant_invoice_path(merchant, invoice_1.id)

      expect(page).to have_content("Total Bulk Discounted Revenue: $240.0")
      
      visit merchant_invoice_path(merchant, invoice_6.id)
      
      expect(page).to have_content("Total Bulk Discounted Revenue: $737.92")
    end
  end

  describe 'Items associated with an invoice belonging to a merchant' do
    it "should display items' name, quantity, unit price" do
      visit merchant_invoice_path(merchant, invoice_1.id)
      
      within("#invoice_items") do
        expect(page).to have_content(invoice_item_1.items_name)
        expect(page).to have_content(invoice_item_1.status)
        expect(page).to have_content(invoice_item_1.quantity)
        expect(page).to have_content(invoice_item_1.format_unit_price)
      end
      
      visit merchant_invoice_path(merchant_1, invoice_6.id)
      
      within("#invoice_items") do
        expect(page).to have_content(invoice_item_6.items_name)
        expect(page).to have_content(invoice_item_6.status)
        expect(page).to have_content(invoice_item_6.quantity)
        expect(page).to have_content(invoice_item_6.format_unit_price)
        expect(page).to have_content(invoice_item_8.status)
        expect(page).to have_content(invoice_item_8.quantity)
        expect(page).to have_content(invoice_item_8.format_unit_price)
      end
    end

    describe 'link to applied discount' do
      it 'invoice item displays link to applied bulk discount show page' do
        visit merchant_invoice_path(merchant, invoice_1.id)

        within("#items-#{invoice_item_1.item_id}") do
          expect(page).to have_link("Green Special")

          click_link("Green Special")
          expect(current_path).to eq(merchant_bulk_discount_path(merchant, bulk_discount_1))
        end

        visit merchant_invoice_path(merchant_1, invoice_6.id)

        within("#items-#{invoice_item_6.item_id}") do
          expect(page).to have_link("Red Special")

          click_link("Red Special")
          expect(current_path).to eq(merchant_bulk_discount_path(merchant, bulk_discount_2))
        end
        visit merchant_invoice_path(merchant_1, invoice_6.id)

        within("#items-#{invoice_item_8.item_id}") do
          expect(page).to have_link("Blue Special")

          click_link("Blue Special")
          expect(current_path).to eq(merchant_bulk_discount_path(merchant_1, bulk_discount_4))
        end
      end

      it 'if no bulk discount applied to this invoice item "No bulk discount applied" appears' do
        visit merchant_invoice_path(merchant, invoice_3.id)

        within("#items-#{invoice_item_9.item_id}") do
          expect(page).to_not have_link("Green Special")
          expect(page).to_not have_link("Red Special")
          expect(page).to_not have_link("Blue Special")
          expect(page).to_not have_link("Yellow Special")
        
          expect(page).to have_content("No bulk discount applied")
        end
      end
    end

    describe 'Selector shows invoice items statuses and they can be updated' do
      it 'should display the selector with a dropdown menu with status options' do
        visit merchant_invoice_path(merchant, invoice_1.id)
        
        within("#invoice_items") do
          expect(page).to have_select(selected: 'pending')
          expect(page).to have_button('Update Item Status')
          
          select("shipped", from: "Status")
          click_button('Update Item Status')
          expect(current_path).to eq(merchant_invoice_path(merchant, invoice_1.id))
        end

        visit merchant_invoice_path(merchant, invoice_6.id)
        
        within("#items-#{invoice_item_6.item_id}") do
          expect(page).to have_select(selected: 'shipped')
          expect(page).to have_button('Update Item Status')
    
          select("packaged", from: "Status")
          click_button('Update Item Status')
          expect(current_path).to eq(merchant_invoice_path(merchant, invoice_6.id))
        end
        
        visit merchant_invoice_path(merchant, invoice_6.id)
        
        within("#items-#{invoice_item_8.item_id}") do
          expect(page).to have_select(selected: 'packaged')
          expect(page).to have_button('Update Item Status')
    
          select("pending", from: "Status")
          click_button('Update Item Status')
          expect(current_path).to eq(merchant_invoice_path(merchant, invoice_6.id))
        end
        
        visit merchant_invoice_path(merchant, invoice_6.id)
        
        expect(page).to have_select(selected: 'packaged')
        expect(page).to have_select(selected: 'pending')
        expect(page).to_not have_select(selected: 'shipped')
        
        visit merchant_invoice_path(merchant, invoice_1.id)
        
        expect(page).to_not have_select(selected: 'packaged')
        expect(page).to_not have_select(selected: 'pending')
        expect(page).to have_select(selected: 'shipped')
      end
    end
  end
end
