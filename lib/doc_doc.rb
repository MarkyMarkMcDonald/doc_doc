require 'doc_doc/version'
require 'doc_doc/horse_and_buggy'
require 'doc_doc/quarantine'
require 'doc_doc/house_call'
require 'doc_doc/patient'
require 'doc_doc/prescription'
require 'doc_doc/treatment'
require 'doc_doc/configuration'

module DocDoc
  def self.prescription(config)
    horse_and_buggy = HorseAndBuggy.new(config.throttle)
    patients = Quarantine.new(horse_and_buggy, config.danger_zone).patients

    treatments = patients.map do |patient|
      visit = HouseCall.new(horse_and_buggy, patient, config.danger_zone)
      visit.start
      illness = visit.illness
      Treatment.new(patient, illness, visit) if illness
    end.compact

    Prescription.new(treatments)
  end
end
