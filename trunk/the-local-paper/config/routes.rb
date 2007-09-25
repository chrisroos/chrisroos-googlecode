ActionController::Routing::Routes.draw do |map|
  map.home '/', :controller => 'articles', :action => 'list'
  map.article ':paper_title/:edition_label/:page_number/:article_title', :controller => 'articles', :action => 'show'
end
