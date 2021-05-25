require 'rails_helper'

describe "Items API", type: :request do
  it "can get all items" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  it 'can return an array of data even if zero resources found' do
    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(0)
    expect(items[:data]).to be_an(Array)
  end

  it "returns a subset of items based on per page limit" do
    create_list(:item, 40)

    get '/api/v1/items', params: { per_page: 20 }

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(20)
  end

  it "returns a subset of items based on limit and page" do
    create_list(:item, 30)

    get '/api/v1/items', params: { per_page: 20, page: 2 }

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(10)

    expect(items[:data].first[:id].to_i).to eq(Item.all[20].id)
    expect(items[:data].first[:attributes][:name]).to eq(Item.all[20].name)
  end

  it "has a limit of 20 results per page if no limit given" do
    create_list(:item, 30)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(20)
    expect(items[:data].first[:attributes][:name]).to eq(Item.first.name)
    expect(items[:data].last[:attributes][:name]).to eq(Item.all[19].name)
  end

  it "can display results based on page number" do
    create_list(:item, 30)

    get '/api/v1/items', params: { page: 2 }

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(10)
    expect(items[:data].first[:attributes][:name]).to eq(Item.all[20].name)
  end

  it 'can get a single item' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item.count).to eq(1)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)
  end

  it 'can find ALL ITEMS based on search criteria' do
    merchant = create(:merchant)
    item1 = merchant.items.create!(name: "The One Ring" ,description: "One ring to rule them all" ,unit_price: 300.52 )
    item2 = merchant.items.create!(name: "Ring Doorbell",description: "Know when someone's at your door",unit_price: 100.83)
    item3 = merchant.items.create!(name: "Headphones",description: "Hear your tunes",unit_price: 50.01)
    item4 = merchant.items.create!(name: "Phone",description: "Call your friends",unit_price: 500.00)
    item5 = merchant.items.create!(name: "M&Ms",description: "Chocolate",unit_price: 1.65)
    item6 = merchant.items.create!(name: "Notebook",description: "Take some notes",unit_price: 3.25)
    item7 = merchant.items.create!(name: "Chicken fingers",description: "fried chicken",unit_price: 3.25)

    query = "name"
    search = "oo"
    get "/api/v1/items/find_all?#{query}=#{search}"
    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(2)
  end

  it "can get the merchant for a given item ID" do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    item1 = create(:item, merchant: merchant1)
    item2 = create(:item, merchant: merchant1)
    item3 = create(:item, merchant: merchant1)
    item4 = create(:item, merchant: merchant2)

    get "/api/v1/items/#{item4.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(merchant[:data]).to be_a Hash

    expect(merchant[:data][:id].to_i).to eq(merchant2.id)
  end
end
