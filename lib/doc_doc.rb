require "doc_doc/version"
require 'doc_doc/horse_and_buggy'

module DocDoc
  def self.prescription(arguments)
    danger_zone = arguments[0]
    throttle = arguments[1]

    horse_and_buggy = HorseAndBuggy.new(throttle)
    patients = Quarantine.new(horse_and_buggy, danger_zone).patients

    treatments = patients.map do |patient|
      visit = HouseVisit.new(horse_and_buggy, patient, danger_zone)
      visit.start
      illness = visit.illness
      Treatment.new(patient, illness, visit) if illness
    end.compact

    Prescription.new(treatments)
  end

  Patient = Struct.new(:home)

  class Quarantine
    def initialize(horse_and_buggy, danger_zone)
      @horse_and_buggy = horse_and_buggy
      @danger_zone = danger_zone
    end

    def patients
      @horse_and_buggy.visit(@danger_zone)
      @horse_and_buggy.all('a').map do |link|
        Patient.new(link['href'])
      end.uniq(&:home)
    end
  end

  class HouseVisit
    def initialize(horse_and_buggy, patient, starting_location)
      @horse_and_buggy = horse_and_buggy
      @patient = patient
      @starting_location = starting_location
    end

    attr_reader :starting_location

    def start
      @horse_and_buggy.visit_house(@patient.home)
      if @horse_and_buggy.status_code >= 400
        @illness = OpenStruct.new(type: 'http', status: @horse_and_buggy.status_code)
      end
    rescue Capybara::Poltergeist::StatusFailError
      @illness = OpenStruct.new(type: 'http', description: 'Could not reach server')
    end

    def illness
      @illness ||= begin
        if @patient.home && @patient.home.match(/#/)
          hyper_fragment = @patient.home.split('#').last
          begin
            nil if @horse_and_buggy.find("##{hyper_fragment}")
          rescue Capybara::Ambiguous
            OpenStruct.new(type: 'fragment', description: 'More than one dom node has this id')
          rescue Capybara::ElementNotFound
            OpenStruct.new(type: 'fragment', description: 'No dom node with this id found')
          end
        else
          nil
        end
      end
    end
  end

  class Prescription
    def initialize(treatments)
      @treatments = treatments
    end

    def treatments
      @treatments
    end

    def to_s
      {
          links: treatments
      }.to_json.to_s
    end
  end

  class Treatment
    def initialize(patient, illness, house_visit)
      @patient = patient
      @illness = illness
      @house_visit = house_visit
    end

    def as_json
      {
          page: @house_visit.starting_location,
          href: @patient.home,
          error: @illness.to_h
      }
    end

    def to_json(_)
      as_json.to_json
    end
  end
end
