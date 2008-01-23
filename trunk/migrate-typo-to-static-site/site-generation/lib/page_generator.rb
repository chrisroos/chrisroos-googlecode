require 'erb_renderer'

class PageGenerator
      
  def initialize(view, template, extension = 'html')
    @view, @template, @extension = view, template, extension
  end
  
  def generate
    FileUtils.mkdir_p(File.join(SITE_ROOT, @view.path))

    erb_template = File.join(TEMPLATE_ROOT, "#{@template}.erb.#{@extension}")
    renderer = ErbRenderer.new(erb_template, @view.binding)
    File.open(File.join(SITE_ROOT, "#{@view.url}.#{@extension}"), 'w') { |io| renderer.render(io) }
  end
  
end