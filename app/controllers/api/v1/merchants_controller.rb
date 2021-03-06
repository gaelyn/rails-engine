class Api::V1::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.limit(per_page).offset(page)
    render json: MerchantSerializer.new(@merchants)
  end

  def show
    @merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(@merchant)
  end

  def find
    @merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%").order(:name).first
    if @merchant
      render json: MerchantSerializer.new(@merchant)
    else
      render json: { error: "Not found" }, status: :not_found
    end
  end
end
