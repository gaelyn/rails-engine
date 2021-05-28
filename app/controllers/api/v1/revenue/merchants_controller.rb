class Api::V1::Revenue::MerchantsController < ApplicationController
  def most_revenue
    @merchants = Merchant.most_revenue(params[:quantity])
    render json: MerchantNameRevenueSerializer.new(@merchants)
  end

  def total_revenue
    @merchant = Merchant.find(params[:id])
    render json: MerchantRevenueSerializer.new(@merchant)
  end

  def potential_revenue
    @merchants = Merchant.potential_revenue(params[:quantity])
    render json: UnshippedOrderSerializer.new(@merchants)
  end
end
