class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  # validates_numericality_of :id
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :merchant_id

  # belongs_to :cart

    # before_destroy do
    #     @invoice = self.invoice
    # end
    #
    # after_destroy do
    #     unless @cart.wishes.any?
    #         @cart.destroy
    #     end
    # end
end
