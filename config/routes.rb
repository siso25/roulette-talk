# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"
  resources :roulettes, only: %i[show create] do
    resources :talk_themes
    resources :speakers
  end
end
