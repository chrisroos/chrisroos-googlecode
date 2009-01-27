class Object
  
  def metaclass
    class << self; self; end
  end
  
  def define_instance_method(sym, &block)
    metaclass.__send__(:define_method, sym, &block)
  end
  
  def stub_instance_method(sym, &block)
    raise "#{self} does not respond to <#{sym}> and therefore cannot be stubbed" unless self.respond_to?(sym)
    define_instance_method(sym, &block)
  end
  
  def __log__
    @__log__ ||= []
  end
  
end