module DocDoc
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
end