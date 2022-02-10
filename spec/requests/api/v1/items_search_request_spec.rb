require 'rails_helper'

RSpec.describe 'items API search' do

  before :each do
    merchant_1 = create(:merchant, name: 'John')
    merchant_2 = create(:merchant, name: 'Jon')
    merchant_3 = create(:merchant, name: 'Jack')
    merchant_4 = create(:merchant, name: 'Jak')
    merchant_5 = create(:merchant, name: 'Jill')
    merchant_6 = create(:merchant, name: 'Jillifer')

    @item_1 = create(:item, unit_price: 10, name: "TasAy", merchant_id: merchant_1.id)
    @item_2 = create(:item, unit_price: 20, name: "tasBy stuff", merchant_id: merchant_1.id)
    @item_3 = create(:item, unit_price: 30, name: "Tasty Beverage", merchant_id: merchant_2.id)
    @item_4 = create(:item, unit_price: 40, name: "Tasty Bev", merchant_id: merchant_3.id)
    @item_5 = create(:item, unit_price: 45, name: "tasty Cocktail", merchant_id: merchant_3.id)
    @item_6 = create(:item, unit_price: 45, name: "Tasty Brew", merchant_id: merchant_3.id)
    @item_7 = create(:item, unit_price: 50, merchant_id: merchant_5.id)
    @item_8 = create(:item, unit_price: 60, merchant_id: merchant_5.id)
    @item_9 = create(:item, unit_price: 70, merchant_id: merchant_5.id)
    @item_10 = create(:item, unit_price: 80, merchant_id: merchant_6.id)
    @item_11 = create(:item, unit_price: 90, merchant_id: merchant_6.id)
  end

  it 'can search for items with similar names' do
    get '/api/v1/items/find_all?name=tasty'
    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items[:data].length).to eq(4)
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

    expect(response).to be_successful

    expect(items[:data].length).to eq(6)
    items[:data].each do |item|
      expect(item[:type]).to eq("item")
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to have_key(:merchant_id)
    end
  end

  it 'can return records by case sensitive alphabetical order' do
    ordered_ids = []
    ordered_names = []

    get '/api/v1/items/find_all?name=tas'
    items = JSON.parse(response.body, symbolize_names: true)

    items[:data].each do |item|
      ordered_ids << item[:id].to_i
      ordered_names << item[:attributes][:name]
    end

    expect(ordered_ids).to eq([@item_1.id, @item_4.id, @item_3.id, @item_6.id, @item_2.id, @item_5.id])
    expect(ordered_names).to eq(['TasAy', 'Tasty Bev', 'Tasty Beverage', 'Tasty Brew', 'tasBy stuff', 'tasty Cocktail'])
  end

  it 'can send one price search queries' do
    get '/api/v1/items/find_all?min_price=60'
    items = JSON.parse(response.body, symbolize_names: true)

    item_ids = []
    items[:data].each do |item|
      item_ids << item[:id].to_i
    end

    expect(item_ids).to eq([@item_8.id, @item_9.id, @item_10.id, @item_11.id])
    #same test different params
    get '/api/v1/items/find_all?max_price=40'
    items = JSON.parse(response.body, symbolize_names: true)

    item_ids = []
    items[:data].each do |item|
      item_ids << item[:id].to_i
    end

    expect(item_ids).to eq([@item_1.id, @item_2.id, @item_3.id, @item_4.id])
  end

  it 'can send multiple price params' do
    get '/api/v1/items/find_all?min_price=40&max_price=60'

    items = JSON.parse(response.body, symbolize_names: true)

    item_ids = []
    items[:data].each do |item|
      item_ids << item[:id].to_i
    end

    expect(item_ids).to eq([@item_4.id, @item_5.id, @item_6.id, @item_7.id, @item_8.id])
  end
end
