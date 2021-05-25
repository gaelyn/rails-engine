class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      @items = Merchant.find(params[:merchant_id]).items
    else
      @items = Item.limit(per_page).offset(page)
    end
    render json: ItemSerializer.new(@items)
  end

  def show
    @item = Item.find(params[:id])
    render json: ItemSerializer.new(@item)
  end

  def find_all
    @items = Item.where("name ilike ?", "%#{params[:name]}%").order(:name)
    render json: ItemSerializer.new(@items)
  end
end
