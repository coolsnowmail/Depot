class ChargesController < ApplicationController
  skip_before_action :authorize, only: [:create]

  def create
    order = Order.find_by(id: params["order_id"])
    if order == nil
      redirect_to store_path, notice: t('charges.number_of_the_order_is_incorrect')
      return
    end
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => (order.total_price * 100).to_i,
      :description => t('charges.order_transaction', order_id: order.id),
      :currency    => 'usd'
    )
    redirect_to store_path, notice: t('charges.notice for successfully stripe payment', order_id: order.id, order_price: order.total_price)

    rescue Stripe::InvalidRequestError => e
      redirect_to store_path, notice: e.message

    rescue Stripe::CardError => e
      redirect_to store_path, notice: e.message
  end
end