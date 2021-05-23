class Api::V1::MerchantsController < ApplicationController
  def index
    render json: Merchant.all
  end

  private

  def merchant_params
    params.require(:merhcant).permit(:name)
  end
end
