require 'rails_helper'

RSpec.describe 'merchants API' do

  before :each do
    create_list(:merchant, 3)
  end

  it 'sends a list of all merchants' do

    get '/api/v1/merchants'

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant[:id]).to be_an Integer
      expect(merchant[:name]).to be_a String
    end
  end

  it 'can get a single merchant' do
    id = Merchant.first.id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(id)
    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a String
  end

end
