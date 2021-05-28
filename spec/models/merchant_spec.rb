require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  before :each do
    @merchant1 = create(:merchant)
    @item = create(:item, merchant: @merchant1)
    @invoice1 = create(:invoice, status: "pending", merchant: @merchant1)
    @invoice2 = create(:invoice, status: "shipped", merchant: @merchant1)
    @invoice_item1 = create(:invoice_item, unit_price: 100.00, quantity: 10, item: @item, invoice: @invoice1)
    @invoice_item2 = create(:invoice_item, unit_price: 200.00, quantity: 10, item: @item, invoice: @invoice2)
    @transaction1 = create(:transaction, invoice: @invoice1)
    @transaction2 = create(:transaction, invoice: @invoice2)

    @merchant2 = create(:merchant)
    @item2 = create(:item, merchant: @merchant2)
    @invoice3 = create(:invoice, status: "pending", merchant: @merchant2)
    @invoice4 = create(:invoice, status: "shipped", merchant: @merchant2)
    @invoice_item3 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: @item2, invoice: @invoice3)
    @invoice_item4 = create(:invoice_item, unit_price: 20.00, quantity: 10, item: @item2, invoice: @invoice4)
    @transaction3 = create(:transaction, invoice: @invoice3)
    @transaction4 = create(:transaction, invoice: @invoice4)

    @merchant3 = create(:merchant)
    @item3 = create(:item, merchant: @merchant3)
    @invoice5 = create(:invoice, status: "pending", merchant: @merchant3)
    @invoice6 = create(:invoice, status: "shipped", merchant: @merchant3)
    @invoice_item5 = create(:invoice_item, unit_price: 1.00, quantity: 10, item: @item3, invoice: @invoice5)
    @invoice_item6 = create(:invoice_item, unit_price: 2.00, quantity: 10, item: @item3, invoice: @invoice6)
    @transaction5 = create(:transaction, invoice: @invoice5)
    @transaction6 = create(:transaction, invoice: @invoice6)
  end

  describe 'class methods' do
    describe '#most_revenue' do
      it 'can order merchants by most revenue' do
        x = 2
        expect(Merchant.most_revenue(x)).to eq([@merchant1, @merchant2])
        expect(Merchant.most_revenue(x).first.revenue).to eq(2000.0)
      end
    end

    describe '#potential_revenue' do
      it 'can order merchants by most potential revenue for items not shipped' do
        x = 1
        expect(Merchant.potential_revenue(x)).to eq([@merchant1])
        expect(Merchant.potential_revenue(x).first.potential_revenue).to eq(1000.0)
      end
    end
  end

  describe 'instance methods' do
    describe '.total_revenue' do
      it 'can calculate a merchants total revenue' do
        expect(@merchant3.total_revenue).to eq(20.0)
      end
    end
  end
end
