require "rails_helper"


RSpec.describe AdminController, :type => :controller do

  describe 'index controller' do
    it 'should test authorize method in app controller' do
      get :index
      expect(response).to redirect_to login_url
    end

    context 'for render' do
      let!(:user) { create(:user) }
      it 'should render index template' do
        session[:user_id] = user.id
        get :index
        expect(response).to render_template(:index)
      end

      it 'should test set_i18n_locale_from_params method in app controller to display error notice' do
        session[:user_id] = user.id
        get :index, locale: :unexisting_locale
        expect(flash.now[:notice]).to eq("unexisting_locale translation not available")
      end

      it 'should test set_i18n_locale_from_params method in app controller to set locale' do
        session[:user_id] = user.id
        get :index, locale: :en
        expect(I18n.locale).to eq(:en)
      end
    end
  end
end