require "rails_helper"


RSpec.describe OrdersController, :type => :controller do
  let!(:user) { create(:user) }
  let!(:product) { create(:product) }
  let!(:order1) { create(:order) }
  let!(:order2) { create(:order) }
  let!(:line_item1) { create(:line_item) }
  let!(:line_item2) { create(:line_item) }
  let!(:cart) { create(:cart) }

  context 'for index orders' do
    before(:each) do
      session[:user_id] = user.id
    end

    it 'should render index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'should insure correct of @orders' do
      get :index
      expect(assigns(:orders)).to eq(Order.all)
    end
  end

  context 'for show orders' do
    before(:each) do
      session[:user_id] = user.id
    end

    it 'should render show template' do
      get :show, id: order1.id
      expect(response).to render_template(:show)
    end

    it 'should insure correct of @order' do
      get :show, id: order1.id
      expect(assigns(:order)).to eq(order1)
    end
  end

  context 'for new order' do
    before(:each) do
      session[:user_id] = user.id
    end

    it 'should set cart for action create orders' do
      get :new
      expect(Cart.all.size).to eq(2)
      expect(flash[:notice]).to eq("Your cart is empty")
    end

    it 'should redirect to store_url' do
      get :new
      expect(response).to redirect_to(store_url)
    end

    it 'should render new template order' do
      cart.line_items << line_item1
      cart.save
      line_item1.save
      session[:cart_id] = cart.id
      get :new, name: "name", address: "address", email: "email@mail.com", pay_type: "Check"
      expect(assigns(:order)).to be_a_new(Order)
    end
  end

  context 'for edit orders' do
    before(:each) do
      session[:user_id] = user.id
    end

    it 'should render edit template' do
      get :edit, id: order1.id
      expect(response).to render_template(:edit)
    end

    it 'should insure correct of @order' do
      get :edit, id: order1.id
      expect(assigns(:order)).to eq(order1)
    end
  end

  context 'for create_orders' do
    before(:each) do
      session[:cart_id] = cart.id
    end

    it 'should add line_items from a cart' do
      post :create, :order => {name: "name", address: "address", email: "email@mail.com", pay_type: 2}
      expect(assigns(:order).line_items).to eq(cart.line_items)
    end

    it 'should create order' do
      post :create, :order => {name: "name", address: "address", email: "email@mail.com", pay_type: 2}
      expect(response).to redirect_to(payment_by_card_order_path(assigns(:order).id))
      expect(flash[:notice]).to eq(I18n.t('.thanks'))
      expect(session[:cart_id]).to eq(nil)
      expect { UserMailer.new_order_alerm(assigns(:order)).deliver }
      .to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'should render new if order not created' do
      post :create, :order => {name: nil, address: nil, email: nil, pay_type: 2}
      expect(response).to render_template(:new)
      expect(assigns(:cart)).to eq(cart)
    end
  end

  context 'for destroy orders' do
    before(:each) do
      session[:user_id] = user.id
    end

    it 'check if destroy orders' do
      expect{ delete :destroy, id: order1.id }.to change(Order, :count).by(-1)
    end

    it 'check if destroy orders and redirect to line_items_url' do
      delete :destroy, id: order1.id
      expect(response).to redirect_to(orders_url)
      expect(flash[:notice]).to eq('Order was successfully destroyed.')
    end
  end

  context 'for 3 equel action' do
    it 'should render payment_by_ym' do
      get :payment_by_ym, id: order1.id
      expect(response).to render_template(:payment_by_ym)
      expect(assigns(:order)).to eq(order1)
    end

    it 'should render payment_by_card' do
      get :payment_by_card, id: order1.id
      expect(response).to render_template(:payment_by_card)
      expect(assigns(:order)).to eq(order1)
    end

    it 'should render payment_by_stripe' do
      get :payment_by_stripe, id: order1.id
      expect(response).to render_template(:payment_by_stripe)
      expect(assigns(:order)).to eq(order1)
    end
  end
end