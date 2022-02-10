require 'rails_helper'

RSpec.describe 'merchant API search' do

  before :each do
    merchant_1 = create(:merchant, name: 'John')
    merchant_2 = create(:merchant, name: 'Jon')
    merchant_3 = create(:merchant, name: 'Jack')
    merchant_4 = create(:merchant, name: 'Jak')
    merchant_5 = create(:merchant, name: 'Jill')
    merchant_6 = create(:merchant, name: 'Jillifer')
  end

  it 'can search for a merchant with query params' do
    get '/api/v1/merchants/find?name=joh'

    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful

    expect(merchant[:data][:type]).to eq("merchant")
    expect(merchant[:data][:attributes][:name]).to eq("John")
  end

  it 'can handle edge cases in search' do
    get '/api/v1/merchants/find?name=jILl'

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant[:data][:type]).to eq("merchant")
    expect(merchant[:data][:attributes][:name]).to eq("Jill")

    get '/api/v1/merchants/find?name=jo'

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant[:data][:type]).to eq("merchant")
    expect(merchant[:data][:attributes][:name]).to eq("John")
  end

  it 'sad path no fragment matched' do
    get '/api/v1/merchants/find?name=zed'

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(merchant[:data]).to eq({:message=>"Merchant not found"})
  end

end
