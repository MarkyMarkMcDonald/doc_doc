require "test_helper"
require "webrick/httpserver"

class DocDocTest < Minitest::Test
  def test_it_does_something_useful
    @server = WEBrick::HTTPServer.new(
        BindAddress: 'localhost',
        Port: 0,
        DocumentRoot: __dir__ + '/../example_documentation_site'
    )
    Thread.new do
      @server.start
    end
    sleep 1

    quarantine_entrance = "http://localhost:#{@server.config[:Port]}"
    prescription = DocDoc.prescription([quarantine_entrance, nil])

    expected_prescription = {
        "links" => [
            {
                "page" => quarantine_entrance,
                "href" => "#{quarantine_entrance}/some-page-that-does-not-exist.html",
                "error" => {
                    "type" => 'http',
                    "status" => 404
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
                    "description" => "Could not reach server"
                }
            }
        ]
    }

    assert_equal(expected_prescription, JSON.parse(prescription.to_s))
  ensure
    @server.shutdown
  end
end
