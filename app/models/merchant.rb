class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :items
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name

  def self.most_revenue(x)
    joins(invoice_items: {invoice: :transactions})
    .where("transactions.result = 'success' AND invoices.status = 'shipped'")
    .group("merchants.id")
    .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .order("revenue DESC")
    .limit(x)
  end

  def total_revenue
    invoice_items
    .joins(:transactions)
    .where("transactions.result = 'success'")
    .sum("quantity * unit_price")
  end
end
