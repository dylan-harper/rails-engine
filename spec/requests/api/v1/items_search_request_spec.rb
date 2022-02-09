require 'rails_helper'

RSpec.describe 'items API search' do

  before :each do
    merchant_1 = create(:merchant, name: 'John')
    merchant_2 = create(:merchant, name: 'Jon')
    merchant_3 = create(:merchant, name: 'Jack')
    merchant_4 = create(:merchant, name: 'Jak')
    merchant_5 = create(:merchant, name: 'Jill')
    merchant_6 = create(:merchant, name: 'Jillifer')

    @item_1 = create(:item, name: "Tasty", merchant_id: merchant_1.id)
    @item_2 = create(:item, name: "tasty stuff", merchant_id: merchant_1.id)
    @item_3 = create(:item, name: "Tasty Beverage", merchant_id: merchant_2.id)
    @item_4 = create(:item, name: "Tasty Bev", merchant_id: merchant_3.id)
    @item_5 = create(:item, name: "Tasty Cocktail", merchant_id: merchant_3.id)
    @item_6 = create(:item, name: "Tasty Brew", merchant_id: merchant_3.id)
    @item_7 = create(:item, merchant_id: merchant_5.id)
    @item_8 = create(:item, merchant_id: merchant_5.id)
    @item_9 = create(:item, merchant_id: merchant_5.id)
    @item_10 = create(:item, merchant_id: merchant_6.id)
    @item_11 = create(:item, merchant_id: merchant_6.id)
  end

  it 'can search for items with similar names' do
    get '/api/v1/items/find_all?name=tasty'

    items = JSON.parse(response.body, symbolize_names: true)

    # expect(response).to be_succesful

    expect(items[:data].length).to eq(6)
    items[:data].each do |item|
      expect(item[:type]).to eq("item")
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to have_key(:merchant_id)
    end
  end

  it 'can search for fragments too' do
    get '/api/v1/items/find_all?name=tas'

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].length).to eq(6)
    items[:data].each do |item|
      expect(item[:type]).to eq("item")
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to have_key(:merchant_id)
    end
  end

end
