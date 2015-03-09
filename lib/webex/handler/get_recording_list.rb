module Webex
  module Handler
    class GetRecordingList < WebexRequest    

      attr_accessor :username, :password, :key

      def xml_body
        <<-XML
          <body>
            <bodyContent xsi:type="java:com.webex.service.binding.ep.LstRecording">
              <listControl>
                <startFrom>0</startFrom>
                <maximumNum>10</maximumNum>
              </listControl>
              <sessionKey>#{key}</sessionKey>
              <hostWebExID>#{username}</hostWebExID>
            </bodyContent>
          </body>
        XML
      end

      private
    
    end
  end
end