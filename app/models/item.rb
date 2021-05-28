class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates_presence_of :name, :description, :unit_price, :merchant_id

  def self.most_revenue(x)
    joins(invoice_items: {invoice: :transactions})
    .where("invoices.status='shipped' AND transactions.result='success'")
    .group("items.id")
    .select("items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .order("revenue DESC")
    .limit(x)
  end

  def total_revenue
    invoice_items
    .joins(invoice: :transactions)
    .where("transactions.result = 'success' AND invoices.status = 'shipped'")
    .sum("invoice_items.quantity * invoice_items.unit_price")
  end
end
