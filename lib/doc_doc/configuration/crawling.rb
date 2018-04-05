module DocDoc
  module Configuration
    module Crawling
      class Options
        attr_reader :boundary, :max_spiderings

        def initialize(boundary = nil, max_spiderings = 0)
          @boundary = boundary
          @max_spiderings = max_spiderings
        end
      end
    end
  end
end