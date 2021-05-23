class Api::V1::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.limit(per_page).offset(page)
    render json: MerchantSerializer.new(@merchants)
  end

  private

  def per_page
    params.fetch(:per_page, 20).to_i
  end

  def page
    page = [params.fetch(:page, 1).to_i, 1].max
    (page - 1) * per_page
  end

  # def merchant_params
  #   params.require(:merhcant).permit(:name)
  # end
end
