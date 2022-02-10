class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :merchant_id

  def self.search_items(params)
    if params[:name]
      items = Item.where('name ILIKE ?', "%#{params[:name]}%").order(:name)
    else
      sort_by_unit_price(params)
    end
  end

  def self.sort_by_unit_price(params)
    if params[:min_price] && params[:max_price]
      Item.where('unit_price >= ?', params[:min_price]).where('unit_price <= ?', params[:max_price])
    elsif params[:min_price]
      Item.where('unit_price >= ?', params[:min_price])
    elsif params[:max_price]
      Item.where('unit_price <= ?', params[:max_price])
    end
  end
end
