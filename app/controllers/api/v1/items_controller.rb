class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(item_params[:id]))
  end

  def create
      item = Item.create(create_item_params)
      render json: ItemSerializer.new(Item.find(item.id)), status: :created
  end

  def update
    item = Item.find(item_params[:id])

    if item_params[:merchant_id]
      Merchant.find(item_params[:merchant_id])
      render_updated_item(item)
    else
      render_updated_item(item)
    end
  end

  def render_updated_item(item)
    item.update(item_params)
    render json: ItemSerializer.new(Item.find(item.id)), status: :ok
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to action: :index
  end


private
  def item_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id)
  end

  def create_item_params
    params[:item].permit(:name, :description, :unit_price, :merchant_id)
  end
end
