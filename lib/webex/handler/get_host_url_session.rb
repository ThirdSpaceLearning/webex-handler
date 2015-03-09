module Webex
  module Handler
    class GetHostUrlSession < WebexRequest    

      attr_accessor :username, :password, :key

      def xml_body
        <<-XML
          <body>
            <bodyContent xsi:type="java:com.webex.service.binding.meeting.GethosturlMeeting">
              <sessionKey>#{key}</sessionKey>
            </bodyContent>
          </body>
        XML
      end

      private
    
    end
  end
end