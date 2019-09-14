Rails.application.routes.draw do
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
    put :mark_fav, on: :member
    get :favourite, on: :collection
    put :report, on: :member
    get :lkjhgertyjnbvftyh, on: :collection
  end

  resources :stories

  devise_for :users, controllers: { registrations: 'users/registrations' }

  get 'dashboard', to: 'home#dashboard'
  get 'accepted_responses', to: 'home#accepted_responses'
  get 'responses', to: 'home#responses'
  get 'questions', to: 'home#questions'
  get 'terms_of_use', to: 'home#terms_of_use'
  get 'privacy_policy', to: 'home#privacy_policy'
  patch 'set_gender', to: 'home#set_gender'
  get 'signin-facebook', to: 'users/omniauth_callbacks#facebook'
  get 'access_restricted', to: 'home#access_restricted'

  resources :posts, controller: 'posts' do
    put :upvote, on: :member
    put :downvote, on: :member
    resources :comments, controller: 'posts/comments' do
      put :upvote, on: :member
      put :downvote, on: :member
    end
  end
  resources :users do
    get :switch, on: :member
    get :posts, on: :member
    put :disconnect, on: :member
    get :notifications, on: :member
    get :connections, on: :collection
    resources :responses do
      put :accept, on: :member
    end
    resources :posts
  end

  resources :chats do
    put :seen, on: :member
  end

  resources :questions do
    put :reorder, on: :collection
  end

  resources :groups do
    get :dashboard, on: :member
    get :responses, on: :member
    get :search, on: :collection
    resources :responses, controller: 'groups/responses' do
      put :accept, on: :member
    end
    resources :questions, controller: 'groups/questions' do
      put :reorder, on: :collection
    end
    resources :posts, controller: 'groups/posts' do
      put :upvote, on: :member
      put :downvote, on: :member
      resources :comments, controller: 'groups/posts/comments' do
        put :upvote, on: :member
        put :downvote, on: :member
      end
    end
  end

  resources :affiliations
  get '/:permalink', to: 'home#show'
end
