require 'rails_helper'

RSpec.describe ChargesController, type: :controller do
  context 'for create action' do
    let!(:order) { create(:order) }
    it 'redirects to store_path' do
      post :create, order_id: order.id
      expect(response).to redirect_to(store_path)
    end

    it 'redirects to store_path' do
      post :create
      expect(response).to redirect_to(store_path)
      expect(flash[:notice]).to eq(I18n.t('charges.number_of_the_order_is_incorrect'))
    end
  end
end
