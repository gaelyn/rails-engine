require 'rails_helper'

describe "Items API", type: :request do
  describe 'happy paths' do
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

    it "returns a subset of items based on per page limit" do
      create_list(:item, 40)

      get '/api/v1/items', params: { per_page: 20 }

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(20)
    end

    it "can display results based on page number" do
      create_list(:item, 30)

      get '/api/v1/items', params: { page: 2 }

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(10)
      expect(items[:data].first[:attributes][:name]).to eq(Item.all[20].name)
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
      search = "ring"
      get "/api/v1/items/find_all?#{query}=#{search}"
      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].count).to eq(2)
    end

    it 'can create a new item' do
      merchant = Merchant.create!(name: "Sauron")
      item_params = {
        "name": "The One Ring",
        "description": "One ring to rule them all",
        "unit_price": 100.99,
        "merchant_id": merchant.id
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last
      expect(response).to be_successful
      expect(response).to have_http_status(:created)
      expect(response.status).to eq(201)
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(merchant.id)
    end

    it "can destroy an item" do
      merchant = Merchant.create!(name: "Isildur")
      item_params = {
        "name": "The One Ring",
        "description": "Cast it into the fire! Destroy it!",
        "unit_price": 100.99,
        "merchant_id": merchant.id
      }
      item = Item.create!(item_params)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "can update an existing item" do
      id = create(:item).id
      previous_description = Item.last.description
      item_params = { description: "Cool new thing" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find(id)

      expect(response).to be_successful
      expect(item.description).to_not eq(previous_description)
      expect(item.description).to eq("Cool new thing")
    end
  end

  describe 'sad paths/edge cases' do
    it 'can return an array of data even if zero items found' do
      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(0)
      expect(items[:data]).to be_an(Array)
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

    it 'shows error if item cannot be created due to missing params' do
      merchant = Merchant.create!(name: "Sauron")
      item_params = {
        "name": "The One Ring",
        "unit_price": 100.99,
        "merchant_id": merchant.id
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      expect(response.status).to eq(422)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
