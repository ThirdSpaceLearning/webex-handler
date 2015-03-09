module Webex
  module Handler
    class DeleteSessionRequest < WebexRequest    

      attr_accessor :username, :password, :key

      # ------------------------------------------------------------------------------------
      # Function to delete meeting:

      # del_meeting($session_key,$username,$password);

      #   $sessionkey -  session key of meeting
      #   $username   -  Host username (who created that meeting)
      #   $password   -  Host password (who created that meeting)
        
      # If meeting is deleted successfully, function would return "SUCCESS"

      # ------------------------------------------------------------------------------------
      def xml_body
        <<-XML
          <body>
            <bodyContent xsi:type="java:com.webex.service.binding.meeting.DelMeeting">
              <meetingKey>#{key}</meetingKey>
            </bodyContent>
          </body>
        XML
      end

      private
    
    end
  end
end