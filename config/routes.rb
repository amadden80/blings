Bling::Application.routes.draw do

  root :to => 'welcome#index'

  match '/test/tone/:frequency' => 'welcome#testTone'
  match '/test/slide/:startFreq/:endFreq' => 'welcome#slideTone'

end
