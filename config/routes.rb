# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, only: %i[create update destroy] do
      post :accept_answer, on: :member
    end
  end
  resources :attachments
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'questions#index'
end
