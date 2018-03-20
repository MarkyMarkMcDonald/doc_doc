require 'capybara/dsl'
require 'selenium/webdriver'
require 'http'

module DocDoc
  class HorseAndBuggy
    include Capybara::DSL
    SECONDS = 1
    DEFAULT_THROTTLE = 1 * SECONDS

    def initialize(throttle = DEFAULT_THROTTLE)
      @throttle = throttle

      Capybara.register_driver :chrome do |app|
        Capybara::Selenium::Driver.new(app, browser: :chrome)
      end

      Capybara.register_driver :headless_chrome do |app|
        capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
            chromeOptions: {args: %w()}
        )

        Capybara::Selenium::Driver.new(
            app,
            browser: :chrome,
            desired_capabilities: capabilities
        )
      end

      Capybara.default_driver = :headless_chrome
      Capybara.match = :one
    end

    def visit_house(href)
      if @throttle
        sleep @throttle
      end
      visit(href)
    end

    def road_closure(destination)
      response = HTTP.follow.get(destination)
      if response.code >= 400
        response.code
      else
        nil
      end
    rescue HTTP::ConnectionError
      'Could not reach destination'
    end
  end
end