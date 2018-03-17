require "doc_doc/version"
require 'doc_doc/horse_and_buggy'
require 'doc_doc/quarantine'
require 'doc_doc/house_visit'
require 'doc_doc/patient'
require 'doc_doc/prescription'
require 'doc_doc/treatment'

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
end
