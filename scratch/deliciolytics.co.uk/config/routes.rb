ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'domains'
  
  map.resources :domains, :only => [:index, :show] do |domain|
    domain.resources :urls, :only => [:index] do |url|
      url.resources :bookmarks, :only => [:index]
    end
    domain.resources :bookmarks, :controller => 'domain_bookmarks'
    domain.resources :events, :only => [:index], :controller => 'domain_events'
  end
  
  map.namespace :admin do |admin|
    admin.resources :domains, :only => [:index, :new, :create]
  end
  
end