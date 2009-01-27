require 'anchor_tag_helper'
require 'mock_request'

module ActionView
  module Helpers
    module UrlHelper
      
      alias :link_to_before_link_validity_check :link_to
      
      def link_to(name, options = {}, html_options = nil, *parameters_for_method_reference)
        anchor_tag = link_to_before_link_validity_check(name, options, html_options, *parameters_for_method_reference)

        anchor_tag_helper = AnchorTagHelper.new(anchor_tag)
        url_without_parameters = anchor_tag_helper.url_without_parameters
        
        mock_request = MockRequest.new(url_without_parameters)
        controller = ActionController::Routing::Routes.recognize(mock_request) rescue nil
        controller_template_name = controller.send(:default_template_name)

        action = mock_request.path_parameters['action']
        template_path = File.expand_path("#{RAILS_ROOT}/app/views/#{controller_template_name}#{action}")

        controller_responds_to_action = if action and action == 'index'
          true
        elsif action
          controller.respond_to?(action) || does_template_exist?(template_path)
        else
          false
        end
        link_class = controller_responds_to_action ? 'valid_href_target' : 'invalid_href_target'
        
        anchor_tag_helper.anchor_with_css_class(link_class)
      end
      
      def does_template_exist?(template_path)
        ['.rhtml', '.rjs', '.rxml'].select { |ext| File.exists?(template_path + ext) }.size > 0
      end
      
    end
  end
end