class Api::V1::ItemsSearchController < ApplicationController
  def index
    items = Item.search_items(item_params)

    if items == nil
      return render json: { data: { message: 'Items not found'}}
    else
      render json: ItemSerializer.new(items)
    end
  end

  private

  def item_params
    params.permit(:name, :unit_price, :max_price, :min_price)
  end
end
