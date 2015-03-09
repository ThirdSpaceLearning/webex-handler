module Webex
  module Handler
    class WebexError

      attr_accessor :code, :result, :reason, :exception_id
    
      def initialize(attributes = {})
        attributes.each do |k, v|
          send("#{k}=", v)
        end
      end

      private

      
    end
  end
end