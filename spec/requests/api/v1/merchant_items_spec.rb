require 'rails_helper'

RSpec.describe 'Merchant Items' do
  describe 'happy path' do
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
  end
end
