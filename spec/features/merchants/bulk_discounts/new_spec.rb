require 'rails_helper' 

RSpec.describe 'Merchant Bulk Discount create' do

  let!(:merchant) { create(:merchant) }

  describe 'Bulk Discount creation' do
    it 'can create a new discount' do
      visit new_merchant_bulk_discount_path(merchant)
      
      expect(page).to have_content("Create a new bulk discount")
      expect(page).to have_content("Name")
      expect(page).to have_content("Percentage discount")
      expect(page).to have_content("Quantity threshold")
      expect(page).to have_button("Submit")

      fill_in("Name", with: "Mother's day sale")
      fill_in("Percentage discount", with: 30)
      fill_in("Quantity threshold", with: 5)
      click_button("Submit")

      expect(current_path).to eq(merchant_bulk_discounts_path(merchant))
      
      expect(page).to have_content("Mother's day sale")
      expect(page).to have_content("Bulk discount succesfully created")
      expect(BulkDiscount.find_by(name: "Mother's day sale").name).to eq("Mother's day sale")
      expect(BulkDiscount.find_by(name: "Mother's day sale").percentage_discount).to eq(30)
      expect(BulkDiscount.find_by(name: "Mother's day sale").quantity_threshold).to eq(5)
    end

    it 'flash alert is provided if percentage discount is not number between 1-99' do
      visit new_merchant_bulk_discount_path(merchant)

      fill_in("Name", with: "Mother's day sale")
      fill_in("Percentage discount", with: 1000)
      fill_in("Quantity threshold", with: 5)
      click_button("Submit")

      expect(current_path).to eq(new_merchant_bulk_discount_path(merchant))

      expect(page).to have_content("Bulk discount not created: name must be filled out and please ensure input for quantity threshold/percentage discount are integers. Additionally percentage discount must be from 1-99")
    end

    it 'flash alert is provided if quantity threshold is not number' do
      visit new_merchant_bulk_discount_path(merchant)

      fill_in("Name", with: "Mother's day sale")
      fill_in("Percentage discount", with: 60)
      fill_in("Quantity threshold", with: "Gidjw dlkjgss")
      click_button("Submit")

      expect(current_path).to eq(new_merchant_bulk_discount_path(merchant))

      expect(page).to have_content("Bulk discount not created: name must be filled out and please ensure input for quantity threshold/percentage discount are integers. Additionally percentage discount must be from 1-99")
    end

    it 'flash alert is provided if name is not filled out' do
      visit new_merchant_bulk_discount_path(merchant)
      
      fill_in("Name", with: "")
      fill_in("Percentage discount", with: 60)
      fill_in("Quantity threshold", with: 7)
      click_button("Submit")

      expect(current_path).to eq(new_merchant_bulk_discount_path(merchant))
      
      expect(page).to have_content("Bulk discount not created: name must be filled out and please ensure input for quantity threshold/percentage discount are integers. Additionally percentage discount must be from 1-99")
    end
  end
end


