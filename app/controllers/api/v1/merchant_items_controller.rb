class Api::V1::MerchantItemsController < ApplicationController

  def index
    merchant = Merchant.find(params[:id])

    if merchant.items.length > 0
      render json: MerchantSerializer.items(merchant.items)
    else
      render :status => 404
    end
  end

end
