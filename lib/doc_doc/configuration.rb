require 'doc_doc/configuration/crawling'

module DocDoc
  module Configuration
    Options = Struct.new(:danger_zone, :throttle, :crawling_options)
  end
end