class Order < ActiveRecord::Base
  enum pay_type: ["By Yandex Money", "By Credit card", "By Stripe"]
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: {in: Order.pay_types.keys}
  has_many :line_items, dependent: :destroy
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
   message: 'Wrong email format'

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end
end
