class Api::V1::ItemsSearchController < ApplicationController

  def index
    items = Item.search_items(item_params)
    render json: ItemSerializer.new(items)
  end

  private

  def item_params
    params.permit(:name, :unit_price, :max_price, :min_price)
  end
end
