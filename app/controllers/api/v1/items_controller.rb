class Api::V1::ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
#
#
  def record_not_found
    render :status => 404

  end
  # def load_item
  #   @item = Item.find(params[:id])
  # end

  # rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  #
  # def record_not_found
  #   render status: 400
  # end

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end


  def create#validate here? potential error response
    item = Item.create(
      name: params["item"]["name"],
      description: params["item"]["description"],
      unit_price: params["item"]["unit_price"].to_f,
      merchant_id: params["item"]["merchant_id"].to_i)

      render json: ItemSerializer.new(Item.find(item.id)), status: :created
  end

  def update#add strong params
    # return render :not_found if Item.find(params[:id]) == nil
    item = Item.find(params[:id])

    if params[:merchant_id]
      Merchant.find(params[:merchant_id])
      render_updated_item(item)
    else
      render_updated_item(item)
    end
  end

  def render_updated_item(item)
    item.update(update_item_params)
    render json: ItemSerializer.new(Item.find(item.id)), status: :ok
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy

    redirect_to action: :index
  end


private
  def update_item_params
    params.permit("name", "description", "unit_price", "merchant_id")
  end

  # def delete_item_params
  # end

end