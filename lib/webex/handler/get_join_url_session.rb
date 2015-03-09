module Webex
  module Handler
    class GetJoinUrlSession < WebexRequest    

      attr_accessor :username, :password, :key, :attendee_name  

      def xml_body
        <<-XML
          <body>
            <bodyContent xsi:type="java:com.webex.service.binding.meeting.GetjoinurlMeeting">
              <sessionKey>#{key}</sessionKey>
              <attendeeName>#{attendee_name}</attendeeName>
            </bodyContent>
          </body>
        XML
      end

      private
    
    end
  end
end