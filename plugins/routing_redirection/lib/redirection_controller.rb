require 'uri_sanitizer'

class RedirectionController < ApplicationController
  
  def permanently_redirect_urls_with_trailing_slash
    uri_sanitizer = UriSanitizer.new(request.request_uri)
    headers['Status'] = '301 Moved Permanently'
    redirect_to uri_sanitizer.location
  end
  
  def permanently_redirect
    if params[:destination_params] && params[:destination_params][:controller]
      headers['Status'] = '301 Moved Permanently'
      redirect_to params.merge(params.delete(:destination_params))
    else
      render :text => 'Not enough information to redirect.', :status => 400
    end
  end
  
end