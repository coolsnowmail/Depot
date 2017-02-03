class OrdersController < ApplicationController
  require 'yandex_money/api'

  include CurrentCart
  skip_before_action :authorize, only: [:new, :create, :payment_by_ym, :payment_by_card, :payment_by_stripe]
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy, :payment_by_ym, :payment_by_card, :payment_by_stripe]


  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    if @cart.line_items.empty?
      redirect_to store_url, notice: 'Your cart is empty'
      return
    end
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        # UserMailer.new_order_alerm(@order).deliver
        if order_params[:pay_type] == 1
          format.html { redirect_to payment_by_ym_order_path(@order), notice: I18n.t('.thanks') }
        end
        if order_params[:pay_type] == 2
          format.html { redirect_to payment_by_card_order_path(@order), notice: I18n.t('.thanks') }
        end
        if order_params[:pay_type] == 3
          format.html { redirect_to payment_by_stripe_order_path(@order.id), notice: I18n.t('.thanks') }
        end
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to payment_form_order_path(@order) }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def payment_by_ym
  end

  def payment_by_card
  end

  def payment_by_stripe
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      par = params.require(:order).permit(:name, :address, :email, :pay_type)
      par[:pay_type] = par[:pay_type].to_i
      return par
    end
end
