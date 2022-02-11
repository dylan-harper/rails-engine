require 'rails_helper'

RSpec.describe 'items API' do

  before :each do
    @merchant = create(:merchant)
    create_list(:item, 3, merchant_id: @merchant.id)

    merchant_2 = create(:merchant)
    create_list(:item, 10, merchant_id: merchant_2.id)

    @merchant_3 = create(:merchant)
  end

  describe 'happy paths' do
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

    it 'can create an item' do
      old_id = Item.last.id
      merchant = Merchant.first

      post ("/api/v1/items"), params: {
        item: {
          name:  Faker::Lorem.characters(number: 5),
          description:  Faker::Lorem.paragraph(sentence_count: 3),
          unit_price:  Faker::Number.decimal(l_digits: 2),
          merchant_id:  merchant.id
        }
      }
      expect(response).to be_successful
      expect(response.status).to eq(201)
      item = Item.last

      expect(item.id).not_to eq(old_id)
      expect(item.name).to be_a String
      expect(item.description).to be_a String
      expect(item.unit_price).to be_a Float
      expect(item.merchant_id).to be_an Integer
      expect(item.merchant_id).to eq(merchant.id)
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

    it 'can delete an item' do
      item_id = Item.last.id

      delete ("/api/v1/items/#{item_id}")
      # expect(response.status).to eq(204)
      expect(Item.last.id).not_to eq(item_id)
    end

    it 'will delete an item, its invoice_item, and its invoice' do
      item_1 = Item.first
      item_2 = Item.last
      customer_1 = create(:customer)
      customer_2 = create(:customer)
      invoice_1 = create(:invoice, customer_id: customer_1.id, merchant_id: @merchant.id)
      invoice_2 = create(:invoice, customer_id: customer_2.id, merchant_id: @merchant.id)
      i_i_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id)
      i_i_2 = create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id)

      delete ("/api/v1/items/#{item_2.id}")

      expect(Item.last).not_to eq(item_2)
      expect(InvoiceItem.last).not_to eq(i_i_2)
      expect(Invoice.last).not_to eq(invoice_2)
    end

    it 'can edit an item attribute' do
      old_item = Item.first

      patch "/api/v1/items/#{old_item.id}", params: {
        name: "New Name"
      }

      item = Item.first
      expect(response).to be_successful
      expect(item.name).to eq("New Name")
      expect(item.description).to eq(old_item.description)
      expect(item.unit_price).to eq(old_item.unit_price)
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
      expect(response).to be_successful
      expect(item.name).to eq("New Name")
      expect(item.description).to eq("New Sentence")
      expect(item.unit_price).to eq(99.9)
      expect(item.merchant_id).to eq(@merchant_3.id)
    end

    it 'can find the associated merchant' do
      get "/api/v1/items/#{Item.first.id}/merchant"

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant[:data][:type]).to eq("merchant")
      expect(merchant[:data][:id]).to eq(@merchant.id.to_s)
      expect(merchant[:data][:attributes][:name]).to eq(@merchant.name)
    end
  end

  describe 'sad paths' do
    it 'will return 404 for a bad integer id' do
      get "/api/v1/items/456456"

      expect(response).not_to be_successful
      expect(response.status).to eq(404)
    end

    it 'returns an error if create is missing an attribute' do
      post ("/api/v1/items"), params: {
        item: {
          # name:  Faker::Lorem.characters(number: 5),
          description:  Faker::Lorem.paragraph(sentence_count: 3),
          unit_price:  Faker::Number.decimal(l_digits: 2),
          merchant_id:  @merchant.id
        }
      }
      expect(response).not_to be_successful
      expect(response.status).to eq(404)
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

  # describe 'edge cases' do
  #   it 'will return 404 for a string id' do
  #     merchant = create(:merchant)
  #     edge_item = create(:item, id: 'test', merchant_id: merchant.id)
  #
  #     get "/api/v1/items/#{edge_item.id}"
  #
  #     expect(response).not_to be_successful
  #     expect(response.status).to eq(404)
  #   end
  # end
end
