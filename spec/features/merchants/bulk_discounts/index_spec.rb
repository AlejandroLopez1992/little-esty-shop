require 'rails_helper'

RSpec.describe 'Merchants Bulk Discount index page' do

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

  static_time_1 = Time.zone.parse('2023-04-13 00:50:37')
  static_time_2 = Time.zone.parse('2023-04-12 00:50:37')

  let!(:invoice_1) { create(:invoice, customer_id: customer_1.id) }
  let!(:invoice_2) { create(:invoice, customer_id: customer_2.id) }
  let!(:invoice_3) { create(:invoice, customer_id: customer_3.id) }
  let!(:invoice_4) { create(:invoice, customer_id: customer_4.id, created_at: static_time_1) }
  let!(:invoice_5) { create(:invoice, customer_id: customer_5.id, created_at: static_time_2) }
  let!(:invoice_6) { create(:invoice, customer_id: customer_6.id) }
  let!(:invoice_7) { create(:invoice, customer_id: customer_6.id) }

  let!(:invoice_item_1) { create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 2) }
  let!(:invoice_item_2) { create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id, status: 2) }
  let!(:invoice_item_3) { create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 2) }
  let!(:invoice_item_4) { create(:invoice_item, item_id: item_4.id, invoice_id: invoice_4.id, status: 0) }
  let!(:invoice_item_5) { create(:invoice_item, item_id: item_5.id, invoice_id: invoice_5.id, status: 0) }
  let!(:invoice_item_6) { create(:invoice_item, item_id: item_6.id, invoice_id: invoice_6.id, status: 1) }
  let!(:invoice_item_7) { create(:invoice_item, item_id: item_9.id, invoice_id: invoice_7.id, status: 1) }

  let!(:inv_1_transaction_s) { create_list(:transaction, 10, result: 1, invoice_id: invoice_1.id) }
  let!(:inv_1_transaction_f) { create_list(:transaction, 5, result: 0, invoice_id: invoice_1.id) }
  let!(:inv_2_transaction_s) { create_list(:transaction, 5, result: 1, invoice_id: invoice_2.id) }
  let!(:inv_3_transaction_s) { create_list(:transaction, 7, result: 1, invoice_id: invoice_3.id) }
  let!(:inv_4_transaction_s) { create_list(:transaction, 3, result: 1, invoice_id: invoice_4.id) }
  let!(:inv_4_transaction_f) { create_list(:transaction, 20, result: 0, invoice_id: invoice_4.id) }
  let!(:inv_5_transaction_s) { create_list(:transaction, 11, result: 1, invoice_id: invoice_5.id) }
  let!(:inv_6_transaction_s) { create_list(:transaction, 8, result: 1, invoice_id: invoice_6.id) }
  
  let!(:bulk_discount_1) { create(:bulk_discount, merchant_id: merchant.id) }
  let!(:bulk_discount_2) { create(:bulk_discount, merchant_id: merchant.id) }
  let!(:bulk_discount_3) { create(:bulk_discount, merchant_id: merchant_1.id) }


  describe 'Page display do' do
    it 'displays all bulk discounts for this merchant & bulk discount name is a link' do
      visit merchant_bulk_discounts_path(merchant)
      
      within("li#bulk_discount_#{bulk_discount_1.id}") do
        expect(page).to have_content(bulk_discount_1.name)
        expect(page).to have_link(bulk_discount_1.name)
        expect(page).to have_content(bulk_discount_1.percentage_discount)
        expect(page).to have_content(bulk_discount_1.quantity_threshold)
      end

      within("li#bulk_discount_#{bulk_discount_2.id}") do
        expect(page).to have_content(bulk_discount_2.name)
        expect(page).to have_link(bulk_discount_2.name)
        expect(page).to have_content(bulk_discount_2.percentage_discount)
        expect(page).to have_content(bulk_discount_2.quantity_threshold)
      end

      expect(page).to_not have_content(bulk_discount_3.name)
      expect(page).to_not have_content(bulk_discount_3.percentage_discount)
      expect(page).to_not have_content(bulk_discount_3.quantity_threshold)

      visit merchant_bulk_discounts_path(merchant_1)

      within("li#bulk_discount_#{bulk_discount_3.id}") do
        expect(page).to have_content(bulk_discount_3.name)
        expect(page).to have_link(bulk_discount_3.name)
        expect(page).to have_content(bulk_discount_3.percentage_discount)
        expect(page).to have_content(bulk_discount_3.quantity_threshold)
      end
    end

    it 'each bulk_discounts name link redirects to its show page' do
      visit merchant_bulk_discounts_path(merchant)

      within("li#bulk_discount_#{bulk_discount_1.id}") do
        expect(page).to have_link(bulk_discount_1.name)
     
        click_link(bulk_discount_1.name)
        expect(current_path).to eq(merchant_bulk_discount_path(merchant, bulk_discount_1))
      end

      visit merchant_bulk_discounts_path(merchant)

      within("li#bulk_discount_#{bulk_discount_2.id}") do
        expect(page).to have_link(bulk_discount_2.name)
     
        click_link(bulk_discount_2.name)
        expect(current_path).to eq(merchant_bulk_discount_path(merchant, bulk_discount_2))
      end

      visit merchant_bulk_discounts_path(merchant_1)

      within("li#bulk_discount_#{bulk_discount_3.id}") do
        expect(page).to have_link(bulk_discount_3.name)
    
        click_link(bulk_discount_3.name)
        expect(current_path).to eq(merchant_bulk_discount_path(merchant_1, bulk_discount_3))
      end
    end
  end

  describe 'Bulk discount Create' do
    it 'index page for merchants shows a link to create a new discount' do
      visit merchant_bulk_discounts_path(merchant)

      within("#bulk_discount_create") do
        expect(page).to have_link("Create Bulk discount")
      end

      visit merchant_bulk_discounts_path(merchant_1)

      within("#bulk_discount_create") do
        expect(page).to have_link("Create Bulk discount")
      end
    end

    it 'clicking the link redirects to form to create new bulk_discount' do
      visit merchant_bulk_discounts_path(merchant)

      within("#bulk_discount_create") do
        click_link("Create Bulk discount")

        expect(current_path).to eq(new_merchant_bulk_discount_path(merchant))
      end

      visit merchant_bulk_discounts_path(merchant_1)

      within("#bulk_discount_create") do
        click_link("Create Bulk discount")

        expect(current_path).to eq(new_merchant_bulk_discount_path(merchant_1))
      end
    end
  end

  describe 'Bulk discount Delete' do
    it 'link to delete a bulk discount appears next to each bulk discount, and when clicked deletes the bulk discount and redirects to merchant bulk item index' do
      visit merchant_bulk_discounts_path(merchant)
      
      within("li#bulk_discount_#{bulk_discount_1.id}") do
        expect(page).to have_link("Delete")
     
        click_link("Delete")
        expect(current_path).to eq(merchant_bulk_discounts_path(merchant))
      end
      
      expect(page).to_not have_content(bulk_discount_1.name)
      expect(page).to_not have_content(bulk_discount_1.quantity_threshold)
      expect(page).to_not have_content(bulk_discount_1.percentage_discount)


      visit merchant_bulk_discounts_path(merchant)

      within("li#bulk_discount_#{bulk_discount_2.id}") do
        expect(page).to have_link("Delete")
      
        click_link("Delete")
        expect(current_path).to eq(merchant_bulk_discounts_path(merchant))
      end

      expect(page).to_not have_content(bulk_discount_2.name)
      expect(page).to_not have_content(bulk_discount_2.quantity_threshold)
      expect(page).to_not have_content(bulk_discount_2.percentage_discount)
    end
  end
end