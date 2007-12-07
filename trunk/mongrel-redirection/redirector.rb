class Redirector
  
  def initialize(request, host_redirection_rules = {}, redirection_rules = {})
    @path = request.params['REQUEST_PATH']
    @host = request.params['HTTP_X_FORWARDED_HOST']
    @uri = request.params['REQUEST_URI']
    @host_redirection_rules = host_redirection_rules
    @redirection_rules = redirection_rules
  end
  
  def redirect_to
    redirect_to = @host_redirection_rules[@host]
    return "http://#{redirect_to}#{@uri}" if redirect_to
    
    redirect_to = @redirection_rules[@host][@path] rescue nil
    return redirect_to if redirect_to
    
    unless @path == '/'
      path_without_trailing_slash = @path.gsub(/\/$/, '')
      return nil if path_without_trailing_slash == @path
      return @uri.gsub(@path, path_without_trailing_slash)
    end
  end
  
end