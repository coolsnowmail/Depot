require "rails_helper"


RSpec.describe CartsController, :type => :controller do

  # let!(:cart) { create(:cart) }
  # context 'for index' do
  #   it 'should check containtion of @carts of index action' do
  #     expect(cart.line_items[0]).to eq(1)
  #   end
  # end

  let!(:user) { create(:user) }
  let!(:cart1) { create(:cart) }
  let!(:cart2) { create(:cart) }
  context 'for index' do
    it 'should render index template' do
      session[:user_id] = user.id
      get :index
      expect(response).to render_template(:index)
    end

    it 'should check containtion of @carts of index action' do
      session[:user_id] = user.id
      get :index
      expect(assigns(:carts)).to eq(Cart.all)
    end
  end

  context 'for show' do
    it 'should render show template' do
      session[:user_id] = user.id
      get :show, id: cart1.id
      expect(response).to render_template(:show)
    end

    it 'should check containtion of @cart of show action' do
      session[:user_id] = user.id
      get :show, id: cart1.id
      expect(assigns(:cart)).to eq(cart1)
    end

    it 'should call invalid_cart method' do
      session[:user_id] = user.id
      get :show, id: 0
      expect(response).to redirect_to store_url
      expect(flash[:notice]).to eq("Invalid cart")
    end
  end

  context 'for new' do
    it 'should render new template' do
      session[:user_id] = user.id
      get :new
      expect(response).to render_template(:new)
    end

    it 'should check containtion of @cart of new action' do
      session[:user_id] = user.id
      get :new
      expect(assigns(:cart)).to be_a_new(Cart)
    end
  end

  context 'for edit' do
    it 'should render edit template' do
      session[:user_id] = user.id
      get :edit, id: cart1.id
      expect(response).to render_template(:edit)
    end
  end

  context 'for create' do
    it 'check if save a new cart and redirect to store_url' do
      post :create
      expect(Cart.all.size).to eq(3)
      expect(response).to redirect_to(store_url)
    end
  end

  context 'for destroy' do
    it 'check if destroy cart and redirect to store_url' do
      session[:cart_id] = cart1.id
      expect{ delete :destroy, id: cart1.id }.to change(Cart, :count).by(-1)
      expect(response).to redirect_to(store_url)
      expect(session[:user_id].present?).to eq(false)
    end
  end
end