class DomainsController < ApplicationController
  
  def index
    @domains = Domain.all
  end
  
  def show
    @domain = Domain.find_by_domain_hash!(params[:id])
  end
  
end