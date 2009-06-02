class BookmarksController < ApplicationController
  
  def index
    @domain    = Domain.find_by_domain_hash!(params[:domain_id])
    @uri       = @domain.urls.find_by_url_hash!(params[:url_id])
    @bookmarks = @uri.bookmarks
  end
  
end