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
end
