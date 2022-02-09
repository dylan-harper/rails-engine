require 'rails_helper'

RSpec.describe 'items API' do

  before :each do
    @merchant = create(:merchant)
    create_list(:item, 3, merchant_id: @merchant.id)

    merchant_2 = create(:merchant)
    create_list(:item, 10, merchant_id: merchant_2.id)

    @merchant_3 = create(:merchant)
  end

  it 'sends a list of all items' do
    get '/api/v1/items'

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items).to be_a Hash
    expect(items[:data].count).to eq(13)

    items[:data].each do |item|
      expect(item[:id]).to be_a String
      expect(item[:attributes][:name]).to be_a String
      expect(item[:attributes][:description]).to be_a String
      expect(item[:attributes][:unit_price]).to be_a Float
      expect(item[:attributes][:merchant_id]).to be_an Integer
    end
  end

  it 'can get a single item' do
    id = Item.first.id
    get "/api/v1/items/#{id}"
    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item[:data][:type]).to eq("item")
    expect(item[:data][:attributes][:name]).to be_a String
    expect(item[:data][:attributes][:description]).to be_a String
    expect(item[:data][:attributes][:unit_price]).to be_a Float
    expect(item[:data][:attributes][:merchant_id]).to eq(Item.first.merchant.id)
  end

  it 'can create an item' do
    old_id = Item.last.id
    merchant = Merchant.first

    post ("/api/v1/items"), params: {
      item: {
        name:  Faker::Lorem.characters(number: 5),
        description:  Faker::Lorem.paragraph(sentence_count: 3),
        unit_price:  Faker::Number.decimal(l_digits: 2),
        merchant_id:  merchant.id#Faker::Number.number(digits: 1)
      }
    }
    # expect(response).to be_succesful
    expect(response.status).to eq(201)
    item = Item.last

    expect(item.id).not_to eq(old_id)
    expect(item.name).to be_a String
    expect(item.description).to be_a String
    expect(item.unit_price).to be_a Float
    expect(item.merchant_id).to be_an Integer
    expect(item.merchant_id).to eq(merchant.id)
  end

  it 'can delete an item' do
    item_id = Item.last.id

    delete ("/api/v1/items/#{item_id}")

    # expect(response).to be_succesful
    # expect(current_path).to eq("/api/v1/items")
    expect(Item.last.id).not_to eq(item_id)
  end

  it 'can edit an item attribute' do
    old_item = Item.first

    patch "/api/v1/items/#{old_item.id}", params: {
      name: "New Name"
    }

    item = Item.first
    # expect(response).to be_succesful
    expect(item.name).to eq("New Name")
    expect(item.description).to eq(old_item.description)
    expect(item.unit_price).to eq(old_item.unit_price)
    # expect(item.merchant_id).to eq(@merchant_3.id)
    expect(item.merchant_id).to eq(@merchant.id)
  end

  it 'can edit all item attributes' do
    old_item = Item.first

    put "/api/v1/items/#{old_item.id}", params: {
      name: "New Name",
      description: "New Sentence",
      unit_price: 99.9,
      merchant_id: @merchant_3.id
    }

    item = Item.first
    # expect(response).to be_succesful
    expect(item.name).to eq("New Name")
    expect(item.description).to eq("New Sentence")
    expect(item.unit_price).to eq(99.9)
    expect(item.merchant_id).to eq(@merchant_3.id)
    # expect(item.merchant_id).not_to eq(@merchant.id)
  end

  it 'can return 404 if merchant doesnt exist' do
    old_item = Item.first

    patch "/api/v1/items/#{old_item.id}", params: {
      name: "New Name",
      description: "New Description",
      unit_price: 42.0,
      merchant_id: 12341
    }

    expect(response.status).to eq(404)
  end

end
