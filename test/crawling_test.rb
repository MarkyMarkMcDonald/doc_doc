require "test_helper"
require "static_server"

class CrawlingTest < Minitest::Test
  def test_it_does_something_useful
    @server = StaticServer.start('example_crawling_start', 0)
    @external_server = StaticServer.start('example_external_site', 7654)

    quarantine_entrance = "http://localhost:#{@server.config[:Port]}"
    external_site_entrance = "http://localhost:7654"

    config = DocDoc::Configuration::Options.new(
        quarantine_entrance,
        nil,
        DocDoc::Configuration::Crawling::Options.new(nil, 2)
    )
    prescription = DocDoc.prescription(config)

    assert_equal(expected_prescription(quarantine_entrance, external_site_entrance), JSON.parse(prescription.to_s))
  ensure
    @server.shutdown
    @external_server.shutdown
  end

  private

  def expected_prescription(quarantine_entrance, external_site)
    {
        "links" => [
            {
                "page" => quarantine_entrance,
                "href" => "#{quarantine_entrance}/some-page-that-does-not-exist.html",
                "error" => {
                    "type" => "http",
                    "description" => 404
                }
            }, {
                "page" => "#{quarantine_entrance}/one-link-away.html",
                "href" => "#{quarantine_entrance}/some-page-that-does-not-exist.html",
                "error" => {
                    "type" => "http",
                    "description" => 404
                }
            }, {
                "page" => "#{quarantine_entrance}/two-links-away.html",
                "href" => "#{quarantine_entrance}/some-page-that-does-not-exist.html",
                "error" => {
                    "type" => "http",
                    "description" => 404
                }
            }, {
                "page" => "#{external_site}/",
                "href" => "#{external_site}/some-page-that-does-not-exist.html",
                "error" => {
                    "type" => "http",
                    "description" => 404
                }
            }, {
                "page" => "#{external_site}/one-link-away.html",
                "href" => "#{external_site}/some-page-that-does-not-exist.html",
                "error" => {
                    "type" => "http",
                    "description" => 404
                }
            }
        ]
    }
  end
end
