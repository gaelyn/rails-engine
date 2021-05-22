class InvoiceItem < ApplicationRecord
  belongs_to :item
belongs_to :invoice
has_one :merchant, through: :item
has_many :transactions, through: :invoice
has_many :bulk_discounts, through: :item

validates_presence_of :quantity,
                      :unit_price,
                      :status,
                      :item_id,
                      :invoice_id
# enum status: [:pending, :packaged, :shipped]
end
