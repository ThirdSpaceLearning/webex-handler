module Webex
  module Handler
    class GetRecordingInfo < WebexRequest    

      attr_accessor :username, :password, :recording_id

      def xml_body
        <<-XML
          <body>
            <bodyContent xsi:type="java:com.webex.service.binding.ep.GetRecordingInfo">
              <recordingID>#{recording_id}</recordingID>
              <isServiceRecording>false</isServiceRecording>
            </bodyContent>
          </body>
        XML
      end

      private
    
    end
  end
end