class Api::V1::ItemsSearchController < ApplicationController
  def index
    items = Item.where('name ILIKE ?', "%#{params[:name]}%")

    if items == nil
      return render json: { data: { message: 'Items not found'}}
    else
      render json: ItemSerializer.new(items)
    end
  end
end
