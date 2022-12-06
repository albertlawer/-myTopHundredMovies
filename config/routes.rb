Rails.application.routes.draw do
  post "signup" => "sessions#signup", as: :signup
  post "login" => "sessions#login", as: :login
  
end
