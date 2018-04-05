require "test_helper"
require "webrick/httpserver"

class LinksOnAPageTest < Minitest::Test
  def test_it_does_something_useful
    @external_server = WEBrick::HTTPServer.new(
        BindAddress: 'localhost',
        Port: 7654,
        DocumentRoot: __dir__ + '/../example_external_site'
    )
    @server = WEBrick::HTTPServer.new(
        BindAddress: 'localhost',
        Port: 0,
        DocumentRoot: __dir__ + '/../example_documentation_site'
    )
    Thread.new do
      @external_server.start
    end
    Thread.new do
      @server.start
    end

    quarantine_entrance = "http://localhost:#{@server.config[:Port]}"
    config = DocDoc::Configuration::Options.new(quarantine_entrance, nil)
    prescription = DocDoc.prescription(config)

    expected_prescription = {
        "links" => [
            {
                "page" => quarantine_entrance,
                "href" => "#{quarantine_entrance}/some-page-that-does-not-exist.html",
                "error" => {
                    "type" => "http",
                    "description" => 404
                }
            },
            {
                "page" => quarantine_entrance,
                "href" => "#{quarantine_entrance}/page_with_too_many_of_the_same_url_fragment.html#what-you-expected",
                "error" => {
                    "type" => "fragment",
                    "description" => "More than one dom node has this id"
                }
            },
            {
                "page" => quarantine_entrance,
                "href" => "#{quarantine_entrance}/page_without_url_fragment.html#what-you-expected",
                "error" => {
                    "type" => "fragment",
                    "description" => "No dom node with this id found"
                }
            },
            {
                "page" => quarantine_entrance,
                "href" => "https://www.nonexistant.example/",
                "error" => {
                    "type" => "http",
                    "description" => "Could not reach destination"
                }
            }
        ]
    }

    assert_equal(expected_prescription, JSON.parse(prescription.to_s))
  ensure
    @server.shutdown
  end
end