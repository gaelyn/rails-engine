require 'rails_helper'

RSpec.describe 'revenue items request, non-RESTful routes' do
  describe 'happy paths' do
    it 'can find top items by revenue' do
      merchant = create(:merchant)
      item1 = create(:item, merchant: merchant)
      item2 = create(:item, merchant: merchant)
      item3 = create(:item, merchant: merchant)
      item4 = create(:item, merchant: merchant)
      item5 = create(:item, merchant: merchant)
      item6 = create(:item, merchant: merchant)
      item7 = create(:item, merchant: merchant)
      item8 = create(:item, merchant: merchant)
      item9 = create(:item, merchant: merchant)
      item10 = create(:item, merchant: merchant)
      invoice1 = create(:invoice, merchant: merchant)

      invoice_item1 = create(:invoice_item, unit_price: 100.00, quantity: 10, item: item1, invoice: invoice1)
      invoice_item2 = create(:invoice_item, unit_price: 1000.00, quantity: 10, item: item2, invoice: invoice1)
      invoice_item3 = create(:invoice_item, unit_price: 500.00, quantity: 10, item: item3, invoice: invoice1)
      invoice_item4 = create(:invoice_item, unit_price: 5.00, quantity: 10, item: item4, invoice: invoice1)
      invoice_item5 = create(:invoice_item, unit_price: 50.00, quantity: 10, item: item5, invoice: invoice1)
      invoice_item6 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: item6, invoice: invoice1)
      invoice_item7 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: item7, invoice: invoice1)
      invoice_item8 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: item8, invoice: invoice1)
      invoice_item9 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: item9, invoice: invoice1)
      invoice_item10 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: item10, invoice: invoice1)

      transaction1 = create(:transaction, invoice: invoice1)

      x = 3

      get "/api/v1/revenue/items?quantity=#{x}"
      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(x)

      expect(items[:data][0][:attributes][:name]).to eq(item2.name)
      expect(items[:data][0][:attributes]).to have_key(:revenue)
      expect(items[:data][0][:attributes][:revenue]).to be_a(Float)
    end
  end

  describe 'sad paths/edge cases' do
    it 'quantity should default to 10 id not provided' do
      merchant = create(:merchant)
      item1 = create(:item, merchant: merchant)
      item2 = create(:item, merchant: merchant)
      item3 = create(:item, merchant: merchant)
      item4 = create(:item, merchant: merchant)
      item5 = create(:item, merchant: merchant)
      item6 = create(:item, merchant: merchant)
      item7 = create(:item, merchant: merchant)
      item8 = create(:item, merchant: merchant)
      item9 = create(:item, merchant: merchant)
      item10 = create(:item, merchant: merchant)
      invoice1 = create(:invoice, merchant: merchant)

      invoice_item1 = create(:invoice_item, unit_price: 100.00, quantity: 10, item: item1, invoice: invoice1)
      invoice_item2 = create(:invoice_item, unit_price: 1000.00, quantity: 10, item: item2, invoice: invoice1)
      invoice_item3 = create(:invoice_item, unit_price: 500.00, quantity: 10, item: item3, invoice: invoice1)
      invoice_item4 = create(:invoice_item, unit_price: 5.00, quantity: 10, item: item4, invoice: invoice1)
      invoice_item5 = create(:invoice_item, unit_price: 50.00, quantity: 10, item: item5, invoice: invoice1)
      invoice_item6 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: item6, invoice: invoice1)
      invoice_item7 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: item7, invoice: invoice1)
      invoice_item8 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: item8, invoice: invoice1)
      invoice_item9 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: item9, invoice: invoice1)
      invoice_item10 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: item10, invoice: invoice1)

      transaction1 = create(:transaction, invoice: invoice1)

      get "/api/v1/revenue/items"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(10)

      expect(items[:data][0][:attributes][:name]).to eq(item2.name)
      expect(items[:data][0][:attributes]).to have_key(:revenue)
      expect(items[:data][0][:attributes][:revenue]).to be_a(Float)
    end
  end
end
