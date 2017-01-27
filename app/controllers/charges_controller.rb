class ChargesController < ApplicationController
  require "stripe"
  skip_before_action :authorize, only: [:create]
  Stripe.api_key = Rails.configuration.stripe[:secret_key]


  def create
    order = Order.find_by(id: params["order_id"])
    if order
      begin
      customer = Stripe::Customer.create(
        :email => params["stripeEmail"],
        :source  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => (order.total_price * 100).to_i,
        :description => "транзакция за ордер #{order.id}",
        :currency    => 'usd'
      )
      rescue Stripe::CardError => e
          flash[:error] = e.message
          redirect_to store_path
      end
      redirect_to store_path, notice: "Order № #{order.id} was successfully paid. Summ was equel #{order.total_price}"
    else
      redirect_to store_path, notice: "Number of the order is incorrect"
    end
  end
end