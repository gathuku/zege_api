Rails.application.routes.draw do
#  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    namespace :v1, defaults: { format: :json} do
      resource :sessions, only:[:create,:destroy]
      resource :users, only:[:index, :create]
      resource :transactions
    end
end
