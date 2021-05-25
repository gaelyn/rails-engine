class Api::V1::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.limit(per_page).offset(page)
    render json: MerchantSerializer.new(@merchants)
  end

  def show
    @merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(@merchant)
    # @merchant = MerchantService.find_by_id(params[:id])
  end
end
