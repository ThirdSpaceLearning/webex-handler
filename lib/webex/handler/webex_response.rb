module Webex
  module Handler
    class WebexResponse

      attr_accessor :code, :result
    
      def initialize(attributes = {})
        attributes.each do |k, v|
          send("#{k}=", v)
        end
      end

      private

      
    
    end
  end
end