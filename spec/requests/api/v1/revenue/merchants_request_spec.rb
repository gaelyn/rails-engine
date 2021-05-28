require 'rails_helper'

RSpec.describe 'revenue merchants request, non-RESTful routes' do
  describe 'happy path' do
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

    it 'can get total revenue for a given merchant' do
      merchant1 = create(:merchant)
      item = create(:item, merchant: merchant1)
      invoice = create(:invoice, merchant: merchant1)
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

      get "/api/v1/revenue/merchants/#{merchant1.id}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data][:attributes]).to_not have_key(:name)
      expect(merchant[:data][:attributes]).to have_key(:revenue)
      expect(merchant[:data][:attributes][:revenue]).to be_a(Float)
      expect(merchant[:data][:attributes][:revenue]).to eq(merchant1.total_revenue)
    end

    it 'can get total potential revenue for a given merchants unshipped items' do
      merchant1 = create(:merchant)
      item = create(:item, merchant: merchant1)
      invoice1 = create(:invoice, status: "pending", merchant: merchant1)
      invoice2 = create(:invoice, status: "shipped", merchant: merchant1)
      invoice_item1 = create(:invoice_item, unit_price: 100.00, quantity: 10, item: item, invoice: invoice1)
      invoice_item2 = create(:invoice_item, unit_price: 200.00, quantity: 10, item: item, invoice: invoice2)
      transaction1 = create(:transaction, invoice: invoice1)
      transaction2 = create(:transaction, invoice: invoice2)

      merchant2 = create(:merchant)
      item2 = create(:item, merchant: merchant2)
      invoice3 = create(:invoice, status: "pending", merchant: merchant2)
      invoice4 = create(:invoice, status: "shipped", merchant: merchant2)
      invoice_item3 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: item2, invoice: invoice3)
      invoice_item4 = create(:invoice_item, unit_price: 20.00, quantity: 10, item: item2, invoice: invoice4)
      transaction3 = create(:transaction, invoice: invoice3)
      transaction4 = create(:transaction, invoice: invoice4)

      merchant3 = create(:merchant)
      item3 = create(:item, merchant: merchant3)
      invoice5 = create(:invoice, status: "pending", merchant: merchant3)
      invoice6 = create(:invoice, status: "shipped", merchant: merchant3)
      invoice_item5 = create(:invoice_item, unit_price: 1.00, quantity: 10, item: item3, invoice: invoice5)
      invoice_item6 = create(:invoice_item, unit_price: 2.00, quantity: 10, item: item3, invoice: invoice6)
      transaction5 = create(:transaction, invoice: invoice5)
      transaction6 = create(:transaction, invoice: invoice6)

      x = 2

      get "/api/v1/revenue/unshipped?quantity=#{x}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(2)
      expect( merchants[:data].last[:attributes][:potential_revenue]).to eq (100.0)
    end
  end
end
