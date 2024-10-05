Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :games, only: %i[create new show] do
    resources :islands, only: %i[create destroy edit new update]
  end

  resources :islands, only: [] do
    resources :available_goods, only: %i[show] do
      get "graph", on: :member
    end

    resources :local_produced_goods
    resources :trades, except: %i[show]
  end

  root "games#new"
end
