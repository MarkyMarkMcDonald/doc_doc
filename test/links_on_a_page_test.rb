require "test_helper"
require "webrick/httpserver"

class LinksOnAPageTest < Minitest::Test
  def test_it_does_something_useful
    @server = start_our_docs_server
    @external_server = start_external_site_server

    quarantine_entrance = "http://localhost:#{@server.config[:Port]}"
    config = DocDoc::Configuration::Options.new(quarantine_entrance, nil)
    prescription = DocDoc.prescription(config)

    assert_equal(expected_prescription(quarantine_entrance), JSON.parse(prescription.to_s))
  ensure
    @server.shutdown
    @external_server.shutdown
  end

  private

  def expected_prescription(quarantine_entrance)
    {
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
  end

  def start_our_docs_server
    server = WEBrick::HTTPServer.new(
        AccessLog: [],
        BindAddress: 'localhost',
        Logger: WEBrick::Log.new(File.open(File::NULL, 'w')),
        Port: 0,
        DocumentRoot: __dir__ + '/../example_documentation_site'
    )
    Thread.new do
      server.start
    end
    server
  end

  def start_external_site_server
    server = WEBrick::HTTPServer.new(
        AccessLog: [],
        Logger: WEBrick::Log.new(File.open(File::NULL, 'w')),
        BindAddress: 'localhost',
        Port: 7654,
        DocumentRoot: __dir__ + '/../example_external_site'
    )
    Thread.new do
      server.start
    end
    server
  end
end
