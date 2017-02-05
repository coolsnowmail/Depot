require "rails_helper"

RSpec.describe StoreController, :type => :controller do
  let!(:cart) { create(:cart) }
  let!(:product1) { create(:product) }
  let!(:product2) { create(:product) }
  before(:each) do
    session[:cart_id] = cart.id
  end

  context 'for store' do
    it 'if locale is not set' do
      get :index
      expect(response).to render_template(:index)
      expect(assigns(:products)).to eq(Product.order(:title))
    end

    it 'if locale is set' do
      get :index, set_locale: 'es'
      expect(response).to redirect_to(store_url(locale: :es))
    end
  end
end