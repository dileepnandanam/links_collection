Rails.application.routes.draw do
  root to: 'links#index'
resources :fucks

  resources :links do
    get :search, on: :collection
    put :tag, on: :member
  end  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
