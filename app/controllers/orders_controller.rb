class OrdersController < ApplicationController
  require 'yandex_money/api'

  include CurrentCart
  skip_before_action :authorize, only: [:new, :create]
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy, :payment_form]

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

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        UserMailer.new_order_alerm(@order).deliver
        format.html { redirect_to payment_form_order_path(@order) }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
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

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def payment_form
    instance_id = YandexMoney::ExternalPayment.get_instance_id(Rails.application.config.yandex_client_id)
    api = YandexMoney::ExternalPayment.new(instance_id.instance_id)

    response = api.request_external_payment(pattern_id: 'p2p',
                                            to:         Rails.application.config.yandex_wallet_id,
                                            amount_due: '1.00', # @order.amount?
                                            message:    'test') # @order.description?

    @form_params = api.process_external_payment(request_id:           response.request_id,
                                                ext_auth_success_uri: 'http://localhost:3000/success_url',
                                                ext_auth_fail_uri:    'http://localhost:3000/fail_url')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type)
    end
end
