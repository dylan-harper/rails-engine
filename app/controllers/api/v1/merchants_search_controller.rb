class Api::V1::MerchantsSearchController < ApplicationController
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  #
  # def record_not_found
  #   render :status => 404
  # end

  def show
    merchant = Merchant.where('name ILIKE ?', "%#{params[:name]}%").first

    if merchant == nil
      return render json: { data: { message: 'Merchant not found'}}
    else
      render json: MerchantSerializer.new(merchant)
    end
  end

end
