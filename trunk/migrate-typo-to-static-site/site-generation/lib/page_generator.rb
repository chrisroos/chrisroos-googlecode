require 'erb_renderer'

class PageGenerator
      
  def initialize(view, template)
    @view, @template = view, template
  end
  
  def generate
    FileUtils.mkdir_p(File.join(SITE_ROOT, @view.path))

    erb_template = File.join(TEMPLATE_ROOT, "#{@template}.erb.html")
    renderer = ErbRenderer.new(erb_template, @view.binding)
    File.open(File.join(SITE_ROOT, "#{@view.url}.html"), 'w') { |io| renderer.render(io) }
  end
  
end