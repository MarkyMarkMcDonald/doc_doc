require 'capybara/dsl'
require 'capybara/poltergeist'

module DocDoc
  class HorseAndBuggy
    include Capybara::DSL
    SECONDS = 1

    def initialize(throttle)
      @throttle = throttle

      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(
            app,
            timeout: 15 * SECONDS,
            phantomjs_options: ['--load-images=no'],
            )
      end
      Capybara.default_driver = :poltergeist
      Capybara.match = :one
    end

    def visit_house(href)
      if @throttle
        sleep @throttle
      end
      visit(href)
    end
  end
end