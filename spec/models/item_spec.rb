require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:merchant_id) }
  end

  before :each do
    @merchant = create(:merchant)
    @item1 = create(:item, merchant: @merchant)
    @item2 = create(:item, merchant: @merchant)
    @item3 = create(:item, merchant: @merchant)
    @item4 = create(:item, merchant: @merchant)
    @item5 = create(:item, merchant: @merchant)
    @item6 = create(:item, merchant: @merchant)
    @item7 = create(:item, merchant: @merchant)
    @item8 = create(:item, merchant: @merchant)
    @item9 = create(:item, merchant: @merchant)
    @item10 = create(:item, merchant: @merchant)
    @invoice1 = create(:invoice, merchant: @merchant)

    @invoice_item1 = create(:invoice_item, unit_price: 100.00, quantity: 10, item: @item1, invoice: @invoice1)
    @invoice_item2 = create(:invoice_item, unit_price: 1000.00, quantity: 10, item: @item2, invoice: @invoice1)
    @invoice_item3 = create(:invoice_item, unit_price: 500.00, quantity: 10, item: @item3, invoice: @invoice1)
    @invoice_item4 = create(:invoice_item, unit_price: 5.00, quantity: 10, item: @item4, invoice: @invoice1)
    @invoice_item5 = create(:invoice_item, unit_price: 50.00, quantity: 10, item: @item5, invoice: @invoice1)
    @invoice_item6 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: @item6, invoice: @invoice1)
    @invoice_item7 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: @item7, invoice: @invoice1)
    @invoice_item8 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: @item8, invoice: @invoice1)
    @invoice_item9 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: @item9, invoice: @invoice1)
    @invoice_item10 = create(:invoice_item, unit_price: 10.00, quantity: 10, item: @item10, invoice: @invoice1)

    @transaction1 = create(:transaction, invoice: @invoice1)

  end

  describe 'class methods' do
    describe '#most_revenue' do
      it 'can order items by most revenue generated' do
        x = 4
        expect(Item.most_revenue(x)).to eq([@item2, @item3, @item1, @item5])
      end
    end
  end

  describe 'instance methods' do
    describe '.total_revenue' do
      it 'can calculate total_revenue for a given item' do
        expect(@item3.total_revenue).to eq(5000.0)
      end
    end
  end
end
