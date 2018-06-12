require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end

      resources :questions, only: %i[index create show], shallow: true do
        resources :answers, only: %i[show create index]
      end
    end
  end

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
    # member do
    #   post :subscribe
    #   delete :unsubscribe
    # end
    resources :answers, concerns: [:votable, :commentable], shallow: true, only: %i[create update destroy] do
      post :accept_answer, on: :member
    end
  end

  resources :subscriptions, only: %i[create destroy]

  resources :attachments

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
