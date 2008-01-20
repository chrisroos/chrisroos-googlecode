require 'erb'
include ERB::Util

class ErbRenderer
  def initialize(template_file, output_file, binding)
    @template_file, @output_file, @binding = template_file, output_file, binding
  end
  def render
    template = File.open(@template_file) { |f| f.read }
    erb = ERB.new(template)
    File.open(File.join(@output_file), 'w') do |file|
      file.puts erb.result(@binding)
    end
  end
end