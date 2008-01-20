require 'erb'
include ERB::Util

class ErbRenderer
  def initialize(template_file, binding)
    @template_file, @binding = template_file, binding
  end
  def render(output_buffer)
    template = File.open(@template_file) { |f| f.read }
    erb = ERB.new(template)
    output_buffer << erb.result(@binding)
  end
end