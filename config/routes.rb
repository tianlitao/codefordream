Rails.application.routes.draw do
  resources :homes
  mount WeixinRailsMiddleware::Engine, at: "/"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
