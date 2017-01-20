Rails.application.routes.draw do

  get 'admin' => 'admin#index'

  controller :sessions do
  get 'login' => :new
  post 'login' => :create
  delete 'logout' => :destroy
  end

  # post  '/пополнение/счета', :to=> 'cabinet/balance#payment_process', :as => :payment_process
  get "payment/call"
  get "sessions/create"
  get "sessions/destroy"
  resources :users

  resources :products do
  get :who_bought, on: :member
  end

  scope '(:locale)' do
    resources :orders
    resources :line_items
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
