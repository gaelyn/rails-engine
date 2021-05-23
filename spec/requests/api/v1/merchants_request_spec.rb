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

    get '/api/v1/merchants', params: { per_page: 20, page: 2 }

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(10)
    expect(merchants[:data].first[:attributes][:name]).to eq(Merchant.all[20].name)
  end
end
