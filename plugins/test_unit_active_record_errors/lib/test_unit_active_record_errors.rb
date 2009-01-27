require 'test_help'

class Test::Unit::ActiveRecordError < Test::Unit::Error
  attr_reader :active_record_model
  def initialize(test_name, exception)
    super
    @active_record_model = exception.record
  end
  def long_display
    msg = super
    msg << "\nActiveRecord Errors: #{active_record_model.errors.full_messages.join(", ")}"
  end
end

class Test::Unit::TestCase

  class << self
    alias :__method_added_without_custom_error_handling :method_added
    def method_added(symbol)
      __method_added_without_custom_error_handling(symbol)
      if symbol.to_s =~ /^test_/ or symbol == :setup or symbol == :teardown
        return if symbol.to_s =~ /_without_custom_error_handling$/
      
        original_method = "__#{symbol}_without_custom_error_handling".to_sym
        if not method_defined?(original_method)
          alias_method original_method, symbol
          define_method(symbol) do
             begin
               __send__(original_method)
             rescue ActiveRecord::RecordInvalid => exception
               add_active_record_error($!)
             end
          end
        end
      end
    end
  end
  
  def add_active_record_error(exception)
    @test_passed = false
    @_result.add_error(Test::Unit::ActiveRecordError.new(name, exception))
  end
  
end