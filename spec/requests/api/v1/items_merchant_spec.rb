require 'rails_helper'

RSpec.describe 'Items Merchant' do
  describe 'happy paths' do
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
      expect(merchant[:data][:attributes][:name]).to eq(merchant2.name)
    end
  end
end
