require 'doc_doc/configuration/crawling'

module DocDoc
  module Configuration
    class Options
      attr_reader :danger_zone, :throttle, :crawling_options

      def initialize(danger_zone, throttle, crawling_options = Crawling::Options.new)
        @danger_zone = danger_zone
        @throttle = throttle
        @crawling_options = crawling_options
      end
    end
  end
end