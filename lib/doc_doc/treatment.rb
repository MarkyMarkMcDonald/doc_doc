module DocDoc
  class Treatment
    def initialize(patient, illness, house_call)
      @patient = patient
      @illness = illness
      @house_call = house_call
    end

    def as_json
      {
          page: @house_call.starting_location,
          href: @patient.home,
          error: @illness.to_h
      }
    end

    def to_json(_)
      as_json.to_json
    end
  end
end