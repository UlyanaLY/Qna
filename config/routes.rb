# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :voteup
      post :votedown
    end
  end
  resources :questions,  concerns: [:votable] do
    resources :answers, concerns: [:votable], shallow: true, only: %i[create update destroy] do
      post :accept_answer, on: :member
    end
  end

  resources :attachments

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
