# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  resources :roulettes, only: %i[show create] do
    resources :talk_themes, only: %i[new create edit update destroy]
    resources :speakers, only: %i[new create edit update destroy]
    resources :templates, only: :create
  end
end
