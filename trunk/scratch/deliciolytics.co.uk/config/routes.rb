ActionController::Routing::Routes.draw do |map|
  
  map.root  :controller => 'domains'
  map.about '/about', :controller => 'static_pages', :action => 'about'
  
  map.resources :domains, :only => [:index, :show, :new, :create] do |domain|
    domain.resources :urls, :only => [:index] do |url|
      url.resources :bookmarks, :only => [:index]
    end
    domain.resources :bookmarks, :controller => 'domain_bookmarks'
    domain.resources :events, :only => [:index], :controller => 'domain_events'
  end
  
end