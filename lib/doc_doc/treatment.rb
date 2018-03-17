module DocDoc
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