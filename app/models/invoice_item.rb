class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  before_destroy do
      @invoice = self.invoice
  end

  after_destroy do
    unless @invoice.invoice_items.any?
        @invoice.destroy
    end
  end
end
