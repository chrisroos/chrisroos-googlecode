class Admin::DomainsController < ApplicationController
  
  def index
    @domains = Domain.all
  end
  
  def new
    @domain = Domain.new
  end
  
  def create
    @domain = Domain.new(params[:domain])
    if @domain.save
      redirect_to admin_domains_path
    else
      render :action => :new
    end
  end
  
end