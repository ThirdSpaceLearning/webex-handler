module Webex
  module Handler
    class CreateSessionRequest < WebexRequest    

      attr_accessor :username, :password, 
                    :topic_name, :agenda, :attendee, :email, :webex_email, :session_date_time, :duration

      #
      # -----------------------------------------------------------------------------
      # Function to create a new meeting:
      #
      # create_meeting($date,$time,$mins,$childname,$topic,$username,$password);
      #  
      #  $date should be in mm/dd/yyyy format
      #  $time should be in HH:ii format (24 hours format)
      #  $mins - duration of session in minutes
      #  $attendee - name of the attendee
      #  $topic - subject/topic of the session
      #  $username - Host username
      #  $password - Host password
      #    
      # This function will return an array having session_key, host url and attendee url
      # --------------------------------------------------------------------------------  
      #
      def xml_body
        <<-XML
          <body>
            <bodyContent xsi:type="java:com.webex.service.binding.meeting.CreateMeeting">
              <accessControl>
                <meetingPassword></meetingPassword>
              </accessControl>
              <metaData>
                <confName>#{topic_name}</confName>
                <agenda>#{agenda}</agenda>
              </metaData>
              <participants>
                <maxUserNumber>2</maxUserNumber>
                <attendees>
                  <attendee>
                    <person>
                      <name>#{attendee}</name>
                      <email>#{email}</email>
                    </person>
                  </attendee>
                </attendees>
              </participants>
              <enableOptions>
                <chat>True</chat>
                <voip>true</voip>
                <poll>true</poll>
                <audioVideo>False</audioVideo>
                <autoDeleteAfterMeetingEnd>false</autoDeleteAfterMeetingEnd>

              <supportShareWebContent>True</supportShareWebContent>

              </enableOptions>
              <schedule>
                <startDate>#{session_date_time}</startDate>
                <openTime>300</openTime>
                <duration>#{duration}</duration>
                <timeZoneID>21</timeZoneID>
              </schedule>
              <telephony>
                <telephonySupport>NONE</telephonySupport>
              </telephony>
            </bodyContent>
          </body>
        XML
      end

      private
    
    end
  end
end