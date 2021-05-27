class Transaction < ApplicationRecord
  belongs_to :invoice
  has_many :invoice_items, through: :invoice
  has_many :items, through: :invoice_items
  has_one :merchant, through: :invoice

  validates_presence_of :invoice_id, :credit_card_number, :result
end
