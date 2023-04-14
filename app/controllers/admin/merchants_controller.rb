class Admin::MerchantsController < ApplicationController
  def index
    @enabled_merchants = Merchant.enabled?
    @disabled_merchants = Merchant.disabled?
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def new
  end

  def create
    merchant = Merchant.new(merchant_params)
    if merchant.save
      flash[:notice] = "Merchant Successfully Created"
      redirect_to admin_merchants_path
    else
      flash[:notice] = "Merchant Not Created: Required Information Missing."
      render :new
    end
  end

  def update
    @merchant = Merchant.find(params[:id])
    if @merchant.update(merchant_params)
      flash[:notice] = "Merchant Info Successfully Updated"
      if params[:name].present?
        redirect_to admin_merchant_path(@merchant)
      elsif params[:status].present?
        redirect_to admin_merchants_path
      end
    else
      flash[:notice] = "Merchant Not Updated: Required Information Missing"
      redirect_to edit_admin_merchant_path(@merchant)
    end
  end

  private
  def merchant_params
    params.permit(:name, :status)
  end
end