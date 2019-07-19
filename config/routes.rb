Rails.application.routes.draw do
  devise_for :users
  root to: 'links#index'
  resources :links do
  	put :retry, on: :member
    get :search, on: :collection
    put :tag, on: :member
    get :desc, on: :collection
    put :hide, on: :member
    put :unhide, on: :member
    get :hidden, on: :collection
    put :untag, on: :member
  end

  resources :stories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
