# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: { registrations: 'registrations', sessions: 'users/sessions' }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  root 'pages#top'
  get  'pages/about' => 'pages#about'
  get  'pages/terms' => 'pages#terms'
  get  'pages/policy' => 'pages#policy'
  resources :users
  resources :posts do
    resources :photos, only: %i[create]
    resources :maps, only: %i[create]
    resources :likes, only: %i[create destroy]
    resources :comments, only: %i[create destroy]
  end
end
