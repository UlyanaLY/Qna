# frozen_string_literal: true

Rails.application.routes.draw do
  resources :questions do
    resources :answers, shallow: true
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'questions#index'
end
