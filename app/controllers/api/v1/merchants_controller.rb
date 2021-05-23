class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  private

  def merchant_params
    params.require(:merhcant).permit(:name)
  end
end
