require 'addressable'

module DocDoc
  class HouseCall
    def initialize(horse_and_buggy, patient, starting_location)
      @horse_and_buggy = horse_and_buggy
      @patient = patient
      @starting_location = starting_location
    end

    attr_reader :starting_location

    def start
      road_closure = @horse_and_buggy.road_closure(@patient.home)
      if road_closure
        @illness = OpenStruct.new(type: 'http', description: road_closure)
      else
        @horse_and_buggy.visit_house(@patient.home)
      end
    rescue => e
      @illness = OpenStruct.new(type: 'http', description: 'Unknown error visiting house', exception: e)
    end

    def illness
      @illness ||= begin
        if address.normalized_fragment
          begin
            nil if @horse_and_buggy.find("[id=\"#{address.normalized_fragment}\"]")
          rescue Capybara::Ambiguous
            OpenStruct.new(type: 'fragment', description: 'More than one dom node has this id')
          rescue Capybara::ElementNotFound
            OpenStruct.new(type: 'fragment', description: 'No dom node with this id found')
          rescue StandardError => e
            if $DEBUG
              puts "[DOC_DOC ERROR] Ran into exception when trying to follow: #{@patient.home}\n#{e.message}"
            end
          end
        else
          nil
        end
      end
    end

    private

    def address
      @address ||= Addressable::URI.parse(@patient.home)
    end
  end
end