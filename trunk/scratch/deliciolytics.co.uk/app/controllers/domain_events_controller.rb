class DomainEventsController < ApplicationController
  
  def index
    @domain = Domain.find_by_domain_hash(params[:domain_id])
    @domain_events = @domain.domain_events
  end
  
end