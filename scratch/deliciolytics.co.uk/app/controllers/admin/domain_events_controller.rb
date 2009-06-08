class Admin::DomainEventsController < ApplicationController
  
  def index
    @domain = Domain.find(params[:domain_id])
    @domain_events = @domain.domain_events
  end
  
end