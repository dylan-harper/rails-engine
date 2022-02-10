class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  #below need to be tested in model_spec
  before_destroy do
      @invoice = self.invoice
  end
  #below need to be tested in model_spec
  after_destroy do
    unless @invoice.invoice_items.any?
        @invoice.destroy
    end
  end
end
