class UrlsController < ApplicationController
  
  def index
    @domain = Domain.find_by_domain_hash!(params[:domain_id])
    @urls   = @domain.urls.all(:order => 'total_posts DESC')
  end
  
end