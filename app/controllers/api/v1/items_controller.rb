class Api::V1::ItemsController < ApplicationController
  def index
    @items = Item.limit(per_page).offset(page)
    render json: ItemSerializer.new(@items)
  end

  private

  def per_page
    params.fetch(:per_page, 20).to_i
  end

  def page
    page = [params.fetch(:page, 1).to_i, 1].max
    (page - 1) * per_page
  end
end
