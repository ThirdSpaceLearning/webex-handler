module Webex
  module Handler
    class WebexRequest

      def initialize(attributes = {})
        attributes.each do |k, v|
          send("#{k}=", v)
        end
      end

      def execute
        call_request
      end

      def formatted_date(date)
        date.utc.strftime('%m/%d/%Y %H:%M:%S') if date
      end

      def xml_header
        <<-XML
          <header>
            <securityContext>
              <webExID>#{username}</webExID>
              <password>#{password}</password>
              <siteID>#{Configuration.site_id}</siteID>
              <partnerID>#{Configuration.partner_id}</partnerID>
            </securityContext>
          </header>
        XML
      end

      def xml_content
        <<-XML
          <?xml version="1.0" encoding="UTF-8"?>
          <serv:message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:serv="http://www.webex.com/schemas/2002/06/service">
            #{xml_header}
            #{xml_body}
          </serv:message>
        XML
      end

      private

      def call_request
        response = make_request

        return_response(response)
      end

      def make_request
        HTTParty.post(Configuration.xml_service_url, body: xml_content)
      end
    
      def return_response response
        if response.code == 200 and response['message']['header']['response']['result'] == 'SUCCESS'
          WebexResponse.new(code: 200, result: response['message']['body']['bodyContent'])
        else
          error_response = response['message']['header']['response']
          result = error_response['result']
          reason = error_response['reason']
          exception_id = error_response['exceptionID']

          WebexError.new(code: 500, result: result, reason: reason, exception_id: exception_id)
        end 
      end
    
    end
  end
end