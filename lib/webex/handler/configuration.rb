module Webex
  module Handler
    class Configuration
    
      %w( site_name site_id partner_id).each do |name|
        define_singleton_method(name) { Settings.send("webex_#{name}") }
      end
    
      def self.xml_service_url
        "https://#{site_name}.webex.com/WBXService/XMLService"
      end
    
    end
  end
end