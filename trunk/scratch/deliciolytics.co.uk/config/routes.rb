ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'domains'
  map.domains 'domains', :controller => 'domains'
  map.route 'domains/:domain_hash', :controller => 'urls'
  map.urls 'domains/:domain_hash/urls', :controller => 'urls'
  
  map.namespace :admin do |admin|
    admin.resources :domains, :only => [:index, :new, :create]
  end
  
end