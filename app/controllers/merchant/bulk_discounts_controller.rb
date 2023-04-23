class Merchant::BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show

  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.create(bulk_discount_params)
    if @bulk_discount.save
      flash[:notice] = "Bulk discount succesfully created"
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:alret] = "Bulk discount not created: name must be filled out and please ensure input for quantity threshold/percentage discount are integers. Additionally percentage discount must be from 1-99"
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :quantity_threshold, :percentage_discount)
  end
end