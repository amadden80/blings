Bling::Application.routes.draw do

  root :to => 'blings#index'

  match '/test' => 'welcome#test'
  match '/test/tone/:frequency' => 'welcome#testTone'
  match '/test/slide/:startFreq/:endFreq' => 'welcome#slideTone'
  match '/test/3rd/:startFreq/:endFreq' => 'welcome#slide3rd'

  # get '/blings_api/:ticker' => 'blings_api#bling_path'
  # get '/blings_api/:email_hash/:ticker' => 'blings_api#bling_path'

  match '/bling' => 'blings#bling'
  match '/bling/:ticker' => 'blings#bling'

  get 'sessions/new' => 'sessions#new'
  post 'sessions' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users, only: [:new, :create, :index, :destroy, :show]
  post 'users/:id' => 'users#show'
  resources :portfolios

end
