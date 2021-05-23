class Api::V1::ItemsController < ApplicationController
  def index
    @items = Item.limit(per_page).offset(page)
    render json: ItemSerializer.new(@items)
  end
end
