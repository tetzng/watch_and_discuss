# frozen_string_literal: true

Rails.application.routes.draw do
  root 'rooms#index'
  resources :rooms do
    member do
      get 'join'
      patch 'play'
    end
    resources :messages, only: %i[index create] do
      resources :likes, only: %i[create destroy]
    end
  end
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
