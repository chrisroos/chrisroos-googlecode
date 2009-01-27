module Test
  module Unit
    module Assertions
      def assert_no_broken_links
        assert_no_tag :tag => 'a', :attributes => { :class => 'invalid_href_target' }
      end
    end
  end
end