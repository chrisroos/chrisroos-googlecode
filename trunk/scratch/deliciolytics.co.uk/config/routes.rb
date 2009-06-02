ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'domains'
  
  map.resources :domains, :only => [:index] do |domain|
    domain.resources :urls, :only => [:index] do |url|
      url.resources :bookmarks, :only => [:index]
    end
  end
  
  map.namespace :admin do |admin|
    admin.resources :domains, :only => [:index, :new, :create]
  end
  
end