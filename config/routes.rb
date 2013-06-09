Bling::Application.routes.draw do

  root :to => 'blings#index'

  match 'test' => 'welcome#test'
  match '/test/tone/:frequency' => 'welcome#testTone'
  match '/test/slide/:startFreq/:endFreq' => 'welcome#slideTone'
  match '/test/3rd/:startFreq/:endFreq' => 'welcome#slide3rd'

end
