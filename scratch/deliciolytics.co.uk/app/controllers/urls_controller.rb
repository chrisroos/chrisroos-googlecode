class UrlsController < ApplicationController
  
  def index
    @domain = Domain.find_by_domain_hash!(params[:domain_hash])
    @urls   = @domain.urls.all(:order => 'total_posts DESC')
  end
  
  def show
    @domain = Domain.find_by_domain_hash!(params[:domain_hash])
    @uri    = @domain.urls.find_by_url_hash!(params[:url_hash])
  end
  
end