module Webex
  module Handler
    class DeleteSessionRecording < WebexRequest    

      attr_accessor :username, :password, :recording_id

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
            <bodyContent xsi:type="java:com.webex.service.binding.ep.DelRecording">
              <recordingID>#{recording_id}</recordingID>
            </bodyContent>
          </body>
        XML
      end

      private
    
    end
  end
end