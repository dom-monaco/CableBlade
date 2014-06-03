Rails.application.routes.draw do
  get 'networks' => 'networks#index'
  get 'shows'    => 'shows#index'
  get 'results'  => 'calculation#results'

  get 'about'   => 'home#about'
  get 'contact' => 'home#contact'
  root 'home#index'

  namespace :admin do
    resources :networks
    resources :shows

    get 'login' => 'logins#new', as: 'logins'
    post 'login' => 'logins#create'
  end
end
