Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Member
  post 'member', to: 'member#new'
  get 'member', to: 'member#index'
  get 'member/:id', to: 'member#show'
end
