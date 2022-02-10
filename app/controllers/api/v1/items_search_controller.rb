class Api::V1::ItemsSearchController < ApplicationController
  def index
    if params[:name]
      items = Item.where('name ILIKE ?', "%#{params[:name]}%").order(:name)
    elsif params[:min_price] && params[:max_price]
      items = Item.where('unit_price >= ?', params[:min_price]).where('unit_price <= ?', params[:max_price])
    elsif params[:min_price]
      items = Item.where('unit_price >= ?', params[:min_price])
    elsif params[:max_price]
      items = Item.where('unit_price <= ?', params[:max_price])
    end

    if items == nil
      return render json: { data: { message: 'Items not found'}}
    else
      render json: ItemSerializer.new(items)
    end
  end
end
