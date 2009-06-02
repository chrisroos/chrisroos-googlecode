class DomainBookmarksController < ApplicationController
  
  def index
    @domain = Domain.find_by_domain_hash!(params[:domain_id])
  end
  
end