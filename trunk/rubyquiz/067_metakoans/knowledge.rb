class Object
  
  def attribute(arg, &block)
  
    if arg.class == Hash
      attribute = arg.keys[0]
      value = arg.values[0]
    else
      attribute = arg
      value = block ? block : nil
    end
    
    class_eval do

      attr_writer attribute
      
      define_method(attribute) do
        unless instance_variable_get("@#{attribute}")
          default_value = (value.class == Proc) ? instance_eval(&value) : value
          instance_variable_set("@#{attribute}", default_value)
        end
        instance_variable_get("@#{attribute}")
      end
    
      define_method("#{attribute}?") do
        instance_variable_get("@#{attribute}") ? true : false
      end
    
    end
  
  end

end