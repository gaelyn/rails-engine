require 'rails_helper'

describe "Merchants API", type: :request do
  it "can get all merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can return an array of data even if zero resources found' do
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(0)
    expect(merchants[:data]).to be_an(Array)
  end

  it "returns a subset of merchants based on per page limit" do
    create_list(:merchant, 40)

    get '/api/v1/merchants', params: { per_page: 20 }

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(20)
  end

  it "returns a subset of merchants based on limit and page" do
    create_list(:merchant, 30)

    get '/api/v1/merchants', params: { per_page: 20, page: 2 }

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(10)

    expect(merchants[:data].first[:id].to_i).to eq(Merchant.all[20].id)
    expect(merchants[:data].first[:attributes][:name]).to eq(Merchant.all[20].name)
  end

  it "has a limit of 20 results per page if no limit given" do
    create_list(:merchant, 30)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(20)
    expect(merchants[:data].first[:attributes][:name]).to eq(Merchant.first.name)
    expect(merchants[:data].last[:attributes][:name]).to eq(Merchant.all[19].name)
  end

  it "can display results based on page number" do
    create_list(:merchant, 30)

    get '/api/v1/merchants', params: { page: 2 }

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(10)
    expect(merchants[:data].first[:attributes][:name]).to eq(Merchant.all[20].name)
  end

  it 'can get a single merchant' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant.count).to eq(1)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it 'can find ONE MERCHANT based on search criteria' do
    merchant1 = Merchant.create!(name: "Turing")
    merchant2 = Merchant.create!(name: "Ring World")
    merchant3 = Merchant.create!(name: "Dunder Mifflin")
    search = "Ring"
    get "/api/v1/merchants/find?name=#{search}"
    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(merchant[:data][:attributes][:name]).to eq("Ring World")
  end

  it 'can show error if no match found for search criteria' do
    merchant1 = Merchant.create!(name: "Turing")
    merchant2 = Merchant.create!(name: "Ring World")
    merchant3 = Merchant.create!(name: "Dunder Mifflin")
    search = "hello"
    get "/api/v1/merchants/find?name=#{search}"
    result = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(result[:error]).to eq("Not found")
  end

  it "can get all items for a given merchant ID" do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    item1 = create(:item, merchant: merchant1)
    item2 = create(:item, merchant: merchant1)
    item3 = create(:item, merchant: merchant1)
    item4 = create(:item, merchant: merchant2)

    get "/api/v1/merchants/#{merchant1.id}/items"

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(3)
    expect(items[:data].first[:id].to_i).to eq(item1.id)
    expect(items[:data].last[:id].to_i).to eq(item3.id)
  end

  it 'can find merchants with the most revenue' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    invoice = create(:invoice, merchant: merchant)
    invoice_item = create(:invoice_item, unit_price: 100.00, quantity: 10, item: item, invoice: invoice)
    transaction = create(:transaction, invoice: invoice)

    merchant2 = create(:merchant)
    item2 = create(:item, merchant: merchant2)
    invoice2 = create(:invoice, merchant: merchant2)
    invoice_item2 = create(:invoice_item, unit_price: 1000.00, quantity: 10, item: item2, invoice: invoice2)
    transaction2 = create(:transaction, invoice: invoice2)

    merchant3 = create(:merchant)
    item3 = create(:item, merchant: merchant3)
    invoice3 = create(:invoice, merchant: merchant3)
    invoice_item3 = create(:invoice_item, unit_price: 500.00, quantity: 10, item: item3, invoice: invoice3)
    transaction3 = create(:transaction, invoice: invoice3)

    x = 2
    get "/api/v1/revenue/merchants?quantity=#{x}"

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    
    expect(merchants[:data].count).to eq(x)
    expect(merchants[:data][0][:attributes][:name]).to eq(merchant2.name)
    expect(merchants[:data][0][:attributes]).to have_key(:revenue)
    expect(merchants[:data][0][:attributes][:revenue]).to be_a(Float)
  end
end
