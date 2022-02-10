class Api::V1::MerchantItemsController < ApplicationController

  def index
    merchant = Merchant.find(merchant_params[:id])

    if merchant.items.length > 0
      render json: MerchantSerializer.items(merchant.items)
    else
      render :status => 404
    end
  end

  def show
    render json: MerchantSerializer.new(Item.find(merchant_params[:id]).merchant)
  end

  private

  def merchant_params
    params.permit(:id)
  end

end
