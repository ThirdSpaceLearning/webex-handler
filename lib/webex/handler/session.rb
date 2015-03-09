module Webex
  module Handler
    class Session
      attr_accessor :username, :password,
                    :topic_name, :agenda, :attendee, :email, :session_date_time, :duration,
                    :key, :host_url, :attendee_url, :code, :recordings
    
      def initialize(attributes = {})
        attributes.each do |k, v|
          send("#{k}=", v)
        end
      end
      
      # usage: 
      # Webex::Handler::Session.create!(username: '[username]', password: '[password]', email: '[email]', topic_name: '[topic name]', agenda: '[agenda]', attendee: '[attendee name]', duration: 60, session_date_time: '[session date time]')
      # 
      # session date time format: %m/%d/%Y %H:%M:%S
      #
      # Example Success Reposne 
      #<Webex::Handler::Session:0x0000010a161d08
      # @agenda="[agenda]",
      # @attendee="[attendee name]",
      # @attendee_url="https://[your domain].webex.com/[your domain]/m.php?AT=JM&MK=[MK value]&AN=[AN value]",
      # @code=200,
      # @duration=60,
      # @email="[email]",
      # @host_url="https://[your domain].webex.com/[your domain]/m.php?AT=HM&MK=[MK value]&Rnd=[Rnd value]",
      # @key="[session key]",
      # @password="[password]",
      # @session_date_time="[session date time]",
      # @topic_name="[topic name]",
      # @username="[username]">

      # Example Error Response:
      # Webex::Handler::WebexError:0x007fa408b757d8
      # @code=500,
      # @exception_id="999999",
      # @reason="Date format should be MM/dd/yyyy HH:mm:ss",
      # @result="FAILURE"

      def self.create! attrs = {}
        session = Session.new(attrs)
        session.code = 200

        request = CreateSessionRequest.new(
          username: session.username,
          password: session.password,
          email: session.email,
          topic_name: session.topic_name,
          agenda: session.agenda,
          attendee: session.attendee,
          session_date_time: session.session_date_time,
          duration: session.duration
        )
        response = request.execute
        return response unless response.code == 200
        session.key = response.result['meetingkey']

        request = GetHostUrlSession.new(username: session.username, password: session.password, key: session.key)
        response = request.execute
        return response unless response.code == 200
        url = URI.unescape(response.result['hostMeetingURL'])
        mu = url.index('MU=')
        session.host_url = url[mu+3..-1]

        request = GetJoinUrlSession.new(username: session.username, password: session.password, key: session.key, attendee_name: session.attendee)
        response = request.execute
        return response unless response.code == 200
        session.attendee_url = response.result['inviteMeetingURL']

        # use direct link, no webex redirection
        # attendee_url = session.host_url.gsub('AT=HM','AT=JM').gsub(/Rnd.*/,"AN=#{session.attendee.to_s.split(' ').first}")

        session
      end

      # usage: 
      # Webex::Handler::Session.destroy(username: '[username]', password: '[password]', key: '[session key]')
      #
      def self.destroy attrs = {}
        session = Session.new(attrs)
        session.code = 200

        request = DeleteSessionRequest.new(
          username: session.username,
          password: session.password,
          key: session.key
        )

        response = request.execute
        response
      end

      # usage:
      # Webex::Handler::Session.download_recording(username: '[username]', password: '[password]', key: '[session key]')
      #
      # Example Success Reposne
      #<Webex::Handler::Session:0x00000109f14cf8
      # @code=200,
      # @key="[session key]",
      # @password="[password]",
      # @username="[username]",
      # @recordings=
      #  [{"recordingID"=>"[recording ID]",
      #    "hostWebExID"=>"[host ID]",
      #    "name"=>"[name]",
      #    "createTime"=>"[create time]",
      #    "timeZoneID"=>"[time zone ID]",
      #    "size"=>"[size]",
      #    "streamURL"=>"[stream URL]",
      #    "fileURL"=>"[file URL]",
      #    "sessionKey"=>"[session key]",
      #    "trackingCode"=>nil,
      #    "recordingType"=>"0",
      #    "duration"=>"[duration]",
      #    "format"=>"ARF",
      #    "serviceType"=>"MeetingCenter",
      #    "passwordReq"=>"false",
      #    "confID"=>"[conf ID]",
      #    "download_url"=>
      #     "[download url]"}
      #  ]
      # >

      def self.download_recording attrs = {}
        session = Session.new(attrs)
        session.code = 200
        session.recordings = []

        request = GetRecordingList.new(
          username: session.username,
          password: session.password,
          key: session.key
        )

        response = request.execute
        return response unless response.code == 200

        # check for multiple recordings
        if response.result['matchingRecords']['total'].to_i == 1
          recordings_array = [response.result['recording']]
        else
          recordings_array = response.result['recording']
        end

        # for each recording get download url
        recordings_array.each do |recording|
          # recording hash to return
          # grab all params from webex
          recording_hash = recording

          # Parsed download attributes
          attributes = get_download_attributes_from_source(recording['fileURL'])
          next if attributes.empty?

          # get webex prepare ticket key
          attributes = get_prepare_ticket_key attributes
          next if attributes.empty?

          # download through child window
          params = ''
          params += '&ticket='+attributes[:ticket]
          params += '&siteurl='+attributes[:siteurl]
          params += '&action='+attributes[:action]
          params += '&recordKey='+attributes[:recordKey]

          download_url = attributes[:downloadUrl] + attributes[:prepare_ticket_key]

          params += '&downloadUrl='+download_url
          params += '&recordName='+attributes[:recordName]

          download_url += params
          # remove empty spaces from url
          download_url = download_url.gsub(/ /, '+')

          # add download url to recording hash
          recording_hash['download_url'] = download_url

          session.recordings << recording_hash
        end

        session
      end

      # usage: 
      #  Webex::Handler::Session.delete_session_recording(username: '[username]', password: '[password]', key: '[session key]')
      # 
      def self.delete_session_recording attrs = {}
        session = Session.new(attrs)
        session.code = 200

        # First get a list of the recordings made
        request = GetRecordingList.new(
          username: session.username,
          password: session.password,
          key: session.key
        )

        response = request.execute
        recordings = response.result['recording']

        results = []
        recordings.each do |recording|
          request = DeleteSessionRecording.new(
            username: session.username,
            password: session.password,
            recording_id: recording['recordingID']
          )
          results << request.execute
        end

        results
      end

      private

      def self.get_download_attributes_from_source file_url
        # processDownloadURL
        uri = URI.parse(file_url)
        html_source = Net::HTTP.get(uri.host, uri.request_uri)
        noko = Nokogiri::HTML(html_source)
        form = noko.xpath("//form")[0]
        attributes = {}

        # postURL
        attributes[:postURL] = form.attributes["action"].value
        return {} unless attributes[:postURL].present?

        # get all froms attributes
        # ticket, siteurl, action, recordKey, recordID
        form.children.each_with_index do |child,i|
          if child.attributes["name"] and child.attributes["value"]
            form_attr  = child.attributes["name"].value
            form_attr_value  = child.attributes["value"].value
            attributes[form_attr.to_sym] = form_attr_value
            return {} unless attributes[form_attr.to_sym].present?
          end
        end

        attributes[:recordName] = noko.css("#recordNameContainer").children.text
        return {} unless attributes[:recordName].present?

        attributes[:downloadUrl] = noko.xpath("//script")[2].text.scan(/downloadUrl = '(.*?)'/).flatten.first
        return {} unless attributes[:downloadUrl].present?

        attributes[:serviceRecordId] = noko.xpath("//script")[2].text.scan(/var serviceRecordId = (.*?);/).flatten.first
        return {} unless attributes[:serviceRecordId].present?

        attributes[:prepareTicket] = noko.xpath("//script")[2].text.scan(/var prepareTicket = '(.*?)'/).flatten.first
        return {} unless attributes[:prepareTicket].present?

        attributes[:iframeURL] = noko.xpath("//script")[2].text.scan(/var url = "(.*?)"/).flatten.first
        return {} unless attributes[:iframeURL].present?

        attributes
      end

      def self.get_prepare_ticket_key attributes
        # Call func_prepare_ticket function
        # Got 'func_prepare_ticket' from child window
        prepare_ticket_url = attributes[:iframeURL] + "&recordid=" + attributes[:recordID] + "&prepareTicket=" + attributes[:prepareTicket]
        if (attributes[:serviceRecordId].to_i > 0)
          prepare_ticket_url += "&serviceRecordId=" + attributes[:serviceRecordId]
        end

        prepare_ticket_uri = URI.parse(prepare_ticket_url)
        html = Net::HTTP.get(prepare_ticket_uri.host, prepare_ticket_uri.request_uri)

        # The key is held in func_prepare('OKOK','','AADQqQe3UUhHEg%3D%3D&timestamp=1371120883361');
        attributes[:prepare_ticket_key] = html.scan(/func_prepare\('OKOK','','(.*?)'/).flatten.first
        return {} unless attributes[:prepare_ticket_key].present?

        attributes
      end

    end
  end
end