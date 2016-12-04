require "rails_helper"

RSpec.describe ProductsController, :type => :controller do
  let!(:user) { create(:user) }
  let!(:product1) { create(:product) }
  let!(:product2) { create(:product) }
  before(:each) do
    session[:user_id] = user.id
  end

  context 'for index product' do
    it 'should render index product template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'should check containtion of @products of index action' do
      get :index
      expect(assigns(:products)).to eq(Product.all)
    end
  end

  context 'for show product' do
    it 'should render show template' do
      get :show, id: product1.id
      expect(response).to render_template(:show)
    end

    it 'should insure correct of @product' do
      get :show, id: product1.id
      expect(assigns(:product)).to eq(product1)
    end
  end

  context 'for new product' do
    it 'should render new template order ' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'should insure correct of @product' do
      get :new
      expect(assigns(:product)).to be_a_new(Product)
    end
  end

  it 'should render edit template order ' do
    get :edit, id: product1.id
    expect(response).to render_template(:edit)
  end

  context 'for create_product' do
    it 'should create product is not create' do
      post :create, :product => {title: "title0", description: "description", image_url: "image_url", price: 2}
      expect(response).to render_template(:new)
    end

    it 'should create product' do
      post :create, :product => {title: "title0", description: "description", image_url: "image_url.png", price: 2}
      expect(response).to redirect_to(assigns(:product))
      expect(flash[:notice]).to eq('Product was successfully created.')
      expect(assigns(:product).title).to eq("title0")
      expect(assigns(:product).description).to eq("description")
      expect(assigns(:product).image_url).to eq("image_url.png")
      expect(assigns(:product).price).to eq(2)
    end
  end

    context 'for update_product' do
    it 'should update product is not updated' do
      post :update, id: product1.id, :product => {title: "title0", description: "description", image_url: "image_url", price: 2}
      expect(response).to render_template(:edit)
    end

    it 'should update product' do
      post :update, id: product1.id, :product => {title: "title0", description: "description", image_url: "image_url.png", price: 2}
      expect(response).to redirect_to(assigns(:product))
      expect(flash[:notice]).to eq('Product was successfully updated.')
    end
  end

  context 'for destroy product' do
    it 'check if destroy product and redirect to products_url' do
      expect{ delete :destroy, id: product1.id }.to change(Product, :count).by(-1)
      expect(response).to redirect_to(products_url)
    end
  end

end