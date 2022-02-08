require 'rails_helper'

RSpec.describe 'merchants API' do

  before :each do
    create_list(:merchant, 3)
  end

  it 'sends a list of all merchants' do

    get '/api/v1/merchants'
    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchants).to be_a Hash
    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant[:id]).to be_an String
      expect(merchant[:attributes][:name]).to be_a String
    end
  end

  it 'can get a single merchant' do
    id = Merchant.first.id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant[:data]).to be_a Hash
    expect(merchant[:data][:attributes]).to have_key(:id)
    expect(merchant[:data][:attributes][:id].to_i).to eq(id)
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a String
  end

  xit 'can list a merchants items' do
    merchant = Merchant.first
    id = merchant.id

    create_list(:item, 3, merchant_id: id)

    get "/api/v1/merchants/#{id}/items"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item).to have_key(:name)
      expect(item).to have_key(:description)
      expect(item).to have_key(:unit_price)
      expect(item).to have_key(:merchant_id)
      expect(item[:name]).to be_a String
      expect(item[:description]).to be_a String
      expect(item[:merchant_id].to_i).to eq(id)
    end
  end

end
