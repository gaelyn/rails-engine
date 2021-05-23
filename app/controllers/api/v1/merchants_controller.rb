class Api::V1::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.limit(per_page).offset(params[:offset])
    render json: MerchantSerializer.new(@merchants)
  end

  private

  def per_page
    params.fetch(:per_page, 20).to_i
  end

  def merchant_params
    params.require(:merhcant).permit(:name)
  end
end
