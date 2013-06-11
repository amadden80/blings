Bling::Application.routes.draw do

  root :to => 'blings#index'

  match '/test' => 'welcome#test'
  match '/test/tone/:frequency' => 'welcome#testTone'
  match '/test/slide/:startFreq/:endFreq' => 'welcome#slideTone'
  match '/test/3rd/:startFreq/:endFreq' => 'welcome#slide3rd'

  match '/bling' => 'blings#bling'

  get 'sessions/new' => 'sessions#new'
  post 'sessions' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users, only: [:new, :create, :index]
  resources :portfolios

end
