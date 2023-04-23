require "rails_helper"

RSpec.describe 'Merchant bulk_discounts edit page' do

  let!(:merchant) { create(:merchant) }
  let!(:merchant_1) { create(:merchant) }
  
  let!(:item_1) { create(:item, merchant_id: merchant.id, description: "Faker is actually really annoying when it creates the same data between multiple objects!!!") }
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

  describe "Edit form" do
    it 'exists and has bulk discount attributes pre-filled' do
      visit edit_merchant_bulk_discount_path(merchant, bulk_discount_1)

      expect(page).to have_content("Edit #{bulk_discount_1.name}'s Information:")
      expect(page).to have_content("Name:")
      expect(find_field('bulk_discount_name').value).to match("#{bulk_discount_1.name}")
      expect(page).to have_content("Percentage discount:")
      expect(find_field('bulk_discount_percentage_discount').value).to match("#{bulk_discount_1.percentage_discount}")
      expect(page).to have_content("Quantity threshold:")
      expect(find_field('bulk_discount_quantity_threshold').value).to match("#{bulk_discount_1.quantity_threshold}")
      expect(page).to have_button("Submit")

      visit edit_merchant_bulk_discount_path(merchant_1, bulk_discount_3)

      expect(page).to have_content("Edit #{bulk_discount_3.name}'s Information:")
      expect(find_field('bulk_discount_name').value).to match("#{bulk_discount_3.name}")
      expect(find_field('bulk_discount_percentage_discount').value).to match("#{bulk_discount_3.percentage_discount}")
      expect(find_field('bulk_discount_quantity_threshold').value).to match("#{bulk_discount_3.quantity_threshold}")
      expect(page).to have_button("Submit")
    end

    it 'when form is filled out correctly and submitted I see a flash message and page is redirected to bulk discount show page' do
      visit edit_merchant_bulk_discount_path(merchant, bulk_discount_1)

      fill_in('bulk_discount_name', with: "Christmas discount")
      fill_in('bulk_discount_percentage_discount', with: 73)
      fill_in('bulk_discount_quantity_threshold', with: 90)
      click_button('Submit')

      expect(current_path).to eq(merchant_bulk_discount_path(merchant, bulk_discount_1))

      expect(page).to have_content("Bulk discount updated succesfully")
      expect(page).to have_content("Christmas discount")
      expect(page).to have_content("73")
      expect(page).to have_content("90")

      visit edit_merchant_bulk_discount_path(merchant_1, bulk_discount_3)

      fill_in('bulk_discount_name', with: "Fathers day discount")
      fill_in('bulk_discount_percentage_discount', with: 20)
      fill_in('bulk_discount_quantity_threshold', with: 4)
      click_button('Submit')

      expect(current_path).to eq(merchant_bulk_discount_path(merchant_1, bulk_discount_3))

      expect(page).to have_content("Bulk discount updated succesfully")
      expect(page).to have_content("Fathers day discount")
      expect(page).to have_content("20")
      expect(page).to have_content("4")
    end

    it 'if form is filled out with incorrect or no info, page redirects to edit page and a flash message is shown' do
      visit edit_merchant_bulk_discount_path(merchant_1, bulk_discount_3)

      fill_in('bulk_discount_name', with: "")
      click_button("Submit")

      expect(current_path).to eq(edit_merchant_bulk_discount_path(merchant_1, bulk_discount_3))
      expect(page).to have_content("Bulk discount not updated: name must be filled out and please ensure input for quantity threshold/percentage discount are integers. Additionally percentage discount must be from 1-99")

      fill_in('bulk_discount_percentage_discount', with: "Five hundred")
      click_button("Submit")

      expect(current_path).to eq(edit_merchant_bulk_discount_path(merchant_1, bulk_discount_3))
      expect(page).to have_content("Bulk discount not updated: name must be filled out and please ensure input for quantity threshold/percentage discount are integers. Additionally percentage discount must be from 1-99")


      fill_in('bulk_discount_quantity_threshold', with: "Seventy five")
      click_button("Submit")

      expect(current_path).to eq(edit_merchant_bulk_discount_path(merchant_1, bulk_discount_3))
      expect(page).to have_content("Bulk discount not updated: name must be filled out and please ensure input for quantity threshold/percentage discount are integers. Additionally percentage discount must be from 1-99")
    end
  end
end