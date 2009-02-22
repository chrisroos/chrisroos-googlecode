module Haml
  module Filters
    module Code
      include Base

      def render(text)
        text = Haml::Helpers.html_escape(text)
        text = Haml::Helpers.preserve(text)
        text
      end
    end
  end
end