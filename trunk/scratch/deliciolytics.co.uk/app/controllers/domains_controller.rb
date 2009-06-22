class DomainsController < ApplicationController
  
  def index
    @domains = Domain.all
  end
  
  def show
    @domain = Domain.find_by_domain_hash!(params[:id])
  end
  
  def new
    @domain = Domain.new
  end
  
  def create
    @domain = Domain.new(params[:domain])
    if @domain.save
      redirect_to domains_path
    else
      render :action => :new
    end
  end
  
end