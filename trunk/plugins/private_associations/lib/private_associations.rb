class ActiveRecord::Base
  class << self
    
    def has_many_private(*args, &blk)
      original_methods = public_instance_methods
      has_many(*args, &blk)
      new_methods = public_instance_methods - original_methods
      private(*new_methods)
    end
    
    def has_one_private(*args, &blk)
      original_methods = public_instance_methods
      has_one(*args, &blk)
      new_methods = public_instance_methods - original_methods
      private(*new_methods)
    end
    
    def belongs_to_private(*args, &blk)
      original_methods = public_instance_methods
      belongs_to(*args, &blk)
      new_methods = public_instance_methods - original_methods
      private(*new_methods)
    end
    
    def has_and_belongs_to_many_private(*args, &blk)
      original_methods = public_instance_methods
      has_and_belongs_to_many(*args, &blk)
      new_methods = public_instance_methods - original_methods
      private(*new_methods)
    end
    
  end
end