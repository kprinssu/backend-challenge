Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Member
  post 'members', to: 'member#new'
  get 'members', to: 'member#index'
  get 'members/:id', to: 'member#show'

  # Friendship
  post 'friendships', to: "member_friendship#new"
end
