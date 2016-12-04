require "rails_helper"


RSpec.describe LineItemsController, :type => :controller do
  let!(:cart) { create(:cart) }
  let!(:user) { create(:user) }
  let!(:line_item1) { create(:line_item) }
  let!(:line_item2) { create(:line_item) }
  let!(:product) { create(:product) }
  let!(:product2) { create(:product) }

  context 'for index line_items' do
    before(:each) do
      session[:user_id] = user.id
    end

    it 'should render index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'should insure correct of @line_items' do
      get :index
      expect(assigns(:line_items)).to eq(LineItem.all)
    end
  end


  context 'for show line_items' do
    before(:each) do
      session[:user_id] = user.id
    end

    it 'should render show template' do
      get :show, id: line_item1.id
      expect(response).to render_template(:show)
      expect(assigns(:line_item)).to eq(line_item1)
    end
  end

  context 'for new line_items' do
    before(:each) do
      session[:user_id] = user.id
    end

    it 'should render new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'should render new template' do
      get :new
      expect(assigns(:line_item)).to be_a_new(LineItem)
    end
  end


  context 'for edit line_items' do
    it 'should render edit template' do
      session[:user_id] = user.id
      get :edit, id: line_item1.id
      expect(response).to render_template(:edit)
    end
  end

  context 'for create line_items' do
    it 'should redirect to @line_item.cart for action create line_items' do
      session[:cart_id] = cart.id
      post :create, {product_id: product.id}
      expect(response).to redirect_to(assigns(:line_item).cart)
      expect(flash[:notice]).to eq('Line item was successfully created.')
    end

    it 'should set cart for action create line_items' do
      post :create, {product_id: product.id}
      expect(Cart.all.size).to eq(2)
      expect(flash[:notice]).to eq('Line item was successfully created.')
    end
  end

  context 'for update line_items' do
    it 'should redirect to @line_item for action update line_items' do
      session[:user_id] = user.id
      put :update, id: line_item1.id, line_item: {product_id: product.id}
      expect(response).to redirect_to(line_item1)
      expect(flash[:notice]).to eq('Line item was successfully updated.')
    end

    it 'should redirect update @line_item' do
      session[:user_id] = user.id
      put :update, id: line_item1.id, line_item: {product_id: product2.id}
      expect(assigns(:line_item).product_id).to eq(product2.id)
    end
  end

  context 'for destroy line_items' do
    it 'check if destroy line_items' do
      session[:user_id] = user.id
      expect{ delete :destroy, id: line_item2.id }.to change(LineItem, :count).by(-1)
    end

    it 'check if destroy line_items and redirect to line_items_url' do
      session[:user_id] = user.id
      delete :destroy, id: line_item2.id
      expect(response).to redirect_to(line_items_url)
    end
  end
end

