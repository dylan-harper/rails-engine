class Api::V1::MerchantItemsController < ApplicationController

  def index
    items = Item.where(merchant_id: merchant_params[:id])

    if items.length > 0
      render json: MerchantSerializer.items(items)
    else
      render :status => 404
    end
  end

  def show
    item = Item.find(merchant_params[:id])
    merchant = Merchant.find(item.merchant_id)
    render json: MerchantSerializer.new(merchant)
  end

  private

  def merchant_params
    params.permit(:id)
  end

end
