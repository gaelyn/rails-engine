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

  def create
    @item = Item.create(item_params)
    if @item.save
      render json: ItemSerializer.new(@item), status: :created
    else
      render :json => {:error =>  "Unprocessable Entity"}.to_json, :status => 422
    end
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  def update
    @item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(@item)
  end

  def find_all
    @items = Item.where("name ilike ?", "%#{params[:name]}%").order(:name)
    render json: ItemSerializer.new(@items)
  end
  
  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
