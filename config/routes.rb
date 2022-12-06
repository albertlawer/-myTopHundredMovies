Rails.application.routes.draw do
  post "signup" => "sessions#signup", as: :signup
  post "login" => "sessions#login", as: :login

  get "search" => "movies#search", as: :search
  get "details" => "movies#details", as: :details
  post "add_to_list" => "movies#add_to_list", as: :add_to_list
  
end
