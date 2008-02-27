module NatRailEnq
  class MessageParser
    def initialize(message)
      @message = message
    end
    def parse
      @message.split('to').collect { |component| component.strip }
    end
  end
end