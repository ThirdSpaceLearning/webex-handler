module Webex
  module Handler
    class GetRecordingLink < WebexRequest    

      attr_accessor :username, :password, :key

      # --------------------------------------------------------------------------------
      # Function to get recording link :

      # getRecordingLink($sessionkey,$username,$password);

      #   $sessionkey -  session key of meeting
      #   $username   -  Host username (who created that meeting)
      #   $password   -  Host password (who created that meeting)
      
      #   This function will return Recording URL of the session only after session is over, 
      #   otherwise blank will be returned
      # --------------------------------------------------------------------------------------

      def xml_body
        <<-XML
          <body>
            <bodyContent xsi:type="java:com.webex.service.binding.ep.LstRecording">
              <sessionKey>#{key}</sessionKey>
            </bodyContent>
          </body>
        XML
      end

      private
    
    end
  end
end