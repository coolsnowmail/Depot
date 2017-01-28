Rails.application.routes.draw do

  get 'admin' => 'admin#index'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  get "sessions/create"
  get "sessions/destroy"
  resources :users

  resources :products do
    get :who_bought, on: :member
  end

  scope '(:locale)' do
    resources :orders do
      member do
        get :payment_by_ym
        get :payment_by_card
        get :payment_by_stripe
      end
    end
    resources :line_items
    resources :charges, only: [:create]
    resources :carts
    root 'store#index', as: 'store', via: :all
  end

  # get 'admin' => 'admin#index'
  # controller :sessions do
  #   get 'login' => :new
  #   post 'login' => :create
  #   delete 'logout' => :destroy
  # end

  # scope '(:locale)' do
  #   resources :orders
  #   resources :line_items
  #   resources :carts
  #   root 'store#index', as: 'store', via: :all
  # end

  # get 'admin/index'
  # get 'sessions/new'
  # get 'sessions/create'
  # get 'sessions/destroy'
  # resources :users

  # resources :products do
  #   get :who_bought, on: :member
  # end

  # root to: 'store#index', as: 'store'
  # resources :orders
  # resources :line_items
  # resources :carts
  # get 'store/index'
end
