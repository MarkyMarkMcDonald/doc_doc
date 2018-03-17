module DocDoc
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
end