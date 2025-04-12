# frozen_string_literal: true

Rails.application.routes.draw do
  root "chats#index"

  resources :chats, only: %i(index show)
  post "chats", to: "chats#upsert", as: :upsert_chat
end
