require "sidekiq/web"

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
    username == Rails.application.credentials.sidekiq[:username] &&
      password == Rails.application.credentials.sidekiq[:password]
  end

  mount Sidekiq::Web => "/sidekiq"

  resources :games, only: %i[create new show] do
    resources :islands, only: %i[create destroy edit new update]
  end

  resources :islands, only: [] do
    resources :available_goods, only: %i[show] do
      get "graph", on: :member
    end

    resources :local_produced_goods, only: %i[create edit new update]
  end

  root "games#new"
end
