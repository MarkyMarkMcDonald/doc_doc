   module DocDoc
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
   end