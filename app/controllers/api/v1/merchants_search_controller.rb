class Api::V1::MerchantsSearchController < ApplicationController

  def show
    merchant = Merchant.where('name ILIKE ?', "%#{params[:name]}%").first
    if merchant == nil
      return render json: { data: { message: 'Merchant not found'}}
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end
