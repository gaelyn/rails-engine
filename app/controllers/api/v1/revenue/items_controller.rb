class Api::V1::Revenue::ItemsController < ApplicationController
  def most_revenue
    x = params[:quantity].to_i
    x = 10 if (x.nil? || x == 0)
    @items = Item.most_revenue(x)
    render json: ItemRevenueSerializer.new(@items)
  end
end
