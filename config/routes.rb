# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :voteup
      post :votedown
    end
  end

  concern :commentable do
    resources :comments,  only: %i[create update destroy]
  end

  resources :questions,  concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true, only: %i[create update destroy] do
      post :accept_answer, on: :member
    end
  end

  resources :attachments

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
