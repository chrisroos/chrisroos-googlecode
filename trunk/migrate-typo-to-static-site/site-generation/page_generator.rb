require File.join(MIGRATOR_ROOT, 'environment')
require File.join(MIGRATOR_ROOT, 'erb_renderer')

class PageGenerator
  
  # Previously we were sending the binding of an article, tag, or page to their respective template.
  # The erb templates still expect to be able to access these variables.
  # This template object allows us to magically define methods on it.  So, for example, we can define an article
  # method that returns an instance of an article.  By instantiating a template for each object in our collection
  # and setting the variable required by the erb template we can remove some duplication.
  # Example.
  # Instead of rendering the article erb template in the context of an article (article.binding)
  # We instantiate a template passing it :article and an article instance.  This gives us an article method on the template
  # that returns our article instance.  We can then render the article erb template in the context of this template
  # object.
  class Template
    def metaclass
      class << self; self; end
    end
    def initialize(object_name, object)
      metaclass.__send__(:define_method, object_name) { object }
    end
    public :binding
  end
      
  def initialize(collection, object_name)
    @collection, @object_name = collection, object_name
  end
  
  def generate
    @collection.each do |object|
      FileUtils.mkdir_p(File.join(SITE_ROOT, object.path))

      erb_template = File.join(TEMPLATE_ROOT, "#{@object_name}.erb.html")
      template = Template.new(@object_name, object)
      
      renderer = ErbRenderer.new(erb_template, template.binding)
      File.open(File.join(SITE_ROOT, "#{object.url}.html"), 'w') { |io| renderer.render(io) }
    end
  end
  
end