module ActionController
  module Routing
    class RouteSet
  
      def recognize(request)
        if request.path =~ /.+\/$/
          request.path_parameters = {:action => 'permanently_redirect_urls_with_trailing_slash'}
          RedirectionController
        else
          params = recognize_path(request.path, extract_request_environment(request))
          request.path_parameters = params.with_indifferent_access
          "#{params[:controller].camelize}Controller".constantize
        end
      end
      
      class Mapper
        def permanently_redirect(path, options = {})
          @set.add_route(path, :controller => 'redirection', :action => 'permanently_redirect', :destination_params => options)
        end
      end
  
    end
  end
end