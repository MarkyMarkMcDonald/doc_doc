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
    patients = []
    treatments = []

    patient_zero = Patient.new(config.danger_zone)

    patients += Quarantine.new(horse_and_buggy, patient_zero.home).patients

    treatments += patients.map do |patient|
      treat(patient_zero.home, horse_and_buggy, patient)
    end.compact

    ill_patients = patients.select do |patient|
      treatments.map(&:patient).include?(patient)
    end

    sub_patients = patients
    (1..config.crawling_options.max_spiderings).each do
      foo = (sub_patients - ill_patients).map do |patient|
        [patient, Quarantine.new(horse_and_buggy, patient.home).patients]
      end

      sub_treatments = foo.flat_map do |sub_patient_zero, sub_sub_patients|
        sub_sub_patients.map do |sub_patient|
          treat(sub_patient_zero.home, horse_and_buggy, sub_patient)
        end.compact
      end

      treatments += sub_treatments
      sub_patients = foo.flat_map do |f| f[1] end
      patients += sub_patients
      ill_patients = patients.select do |patient|
        treatments.map(&:patient).include?(patient)
      end
    end

    Prescription.new(treatments.sort_by(&:starting_location))
  end

  private

  def self.treat(starting_place, horse_and_buggy, patient)
    visit = HouseCall.new(horse_and_buggy, patient, starting_place)
    visit.start
    illness = visit.illness
    Treatment.new(patient, illness, visit) if illness
  end
end
