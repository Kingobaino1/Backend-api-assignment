Rails.application.routes.draw do
  namespace :api do
    namespace :inbound do
      resources :sms
    end

  end

  namespace :api do
    namespace :outbound do
      resources :sms
    end
  end

  namespace :api do
    namespace :v1 do
      resources :accounts, only: :create
      resources :phone_numbers, only: [:create, :index]
    end
  end
end
