require "rails_helper"

RSpec.describe SessionsController, :type => :controller do
  let!(:user) { create(:user) }

  context 'for create session' do
    it 'should create session if user exists' do
      post :create, name: user.name, password: user.password
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(admin_url)
    end

    it 'should redirect_to admin_url if name or password incorrect' do
      post :create, name: user.name, password: nil
      expect(response).to redirect_to(login_url)
      expect(flash[:alert]).to eq("Wrong name or password")
    end
  end

  context 'for destroy session' do
    before(:each) do
      session[:user_id] = user.id
    end

    it 'should destroy user session' do
        post :destroy
        expect(session[:user_id]).to eq(nil)
        expect(response).to redirect_to(store_url)
        expect(flash[:notice]).to eq("The session is over")
    end
  end
end