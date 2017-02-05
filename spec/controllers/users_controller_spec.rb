require "rails_helper"

RSpec.describe UsersController, :type => :controller do
  let!(:user) { create(:user) }
  before(:each) do
    session[:user_id] = user.id
  end

  context 'for index user' do
    it 'should render index user template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'should check containtion of @users of index action' do
      get :index
      expect(assigns(:users)).to eq(User.order(:name))
    end
  end

  context 'for show user' do
    it 'should render show template' do
      get :show, id: user.id
      expect(response).to render_template(:show)
    end

    it 'should insure correct of @user' do
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
  end

  context 'for new user' do
    it 'should render new template user ' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'should insure correct of @user' do
      get :new, name: "name", password: "password", password_confirmation: "password"
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  it 'should render edit template user ' do
    get :edit, id: user.id
    expect(response).to render_template(:edit)
  end

  context 'for create_user' do
    it 'should create user is not create' do
      post :create, :user => { name: nil, password: "password", password_confirmation: "password" }
      expect(response).to render_template(:new)
    end

    it 'should create user' do
      post :create, :user => { name: "name0", password: "password", password_confirmation: "password" }
      expect(response).to redirect_to(users_url)
      expect(flash[:notice]).to eq("User #{assigns(:user).name} was successfully created.")
    end
  end

    context 'for update_user' do
    it 'should update user is not updated' do
      post :update, id: user.id, :user => {name: nil, password: "password", password_confirmation: "password"}
      expect(response).to render_template(:edit)
    end

    it 'should update user' do
      post :update, id: user.id, :user => {name: "nameuser", password: "password", password_confirmation: "password"}
      expect(response).to redirect_to(users_url)
      expect(flash[:notice]).to eq("User #{assigns(:user).name} was successfully updated.")
    end
  end

  context 'for destroy user' do
    let!(:user1) { create(:user) }
    it 'check if destroy user and redirect to users_url' do
      expect{ delete :destroy, id: "#{user.id}" }.to change(User, :count).by(-1)
      expect(response).to redirect_to(users_url)
      expect(flash[:notice]).to eq("Пользователь #{assigns(:user).name} удален")
    end
    it 'check not destroing last user' do
      user1.destroy
      delete :destroy, id: "#{user.id}"
      expect(response).to redirect_to(users_url)
      expect(flash[:notice]).to eq("Последний пользователь не может быть удален")
    end
  end
end