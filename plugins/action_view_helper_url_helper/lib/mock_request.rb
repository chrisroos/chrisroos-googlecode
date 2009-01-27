class MockRequest
  
  attr_reader :path
  attr_accessor :path_parameters
  
  def initialize(path)
    @path = path
  end
  
end