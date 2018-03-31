# DocDoc

A Doc[tor] for your Doc[umentation]'s invalid links.


## Installation

```
$ gem install doc_doc
```

## Goal

Doc Doc strives to find sick links for you to treat. Doc Doc finds links that:

- lead to pages that do not load (http statuses in the 400 or 500 ranges)
- lead to pages without the elements referenced by the link's url fragment


## Usage

#### Checking a single web-page

```
$ doc_doc 'https://github.com/SeleniumHQ/selenium/wiki/Logging' > invalid_links.json
```

`invalid_links.json` identifies links that could use a little doctoring:

```json
{
  "links": [
    {
      "page": "https://github.com/SeleniumHQ/selenium/wiki/Logging",
      "href": "../DesiredCapabilities",
      "error": {
        "type": "http",
        "status": 404
      }
    }
  ]
}
```

#### Crawling across across multiple pages of documentation

```
$ doc_doc 'https://github.com/SeleniumHQ/selenium/wiki/Logging' --crawl-within 'https://github.com/SeleniumHQ/selenium/wiki' > invalid_links.json
```

When the `crawl-within` option is set, Doc doc will also check links on pages linked out to from the starting page, so long as the url of those pages are prefixed with the `crawl-within` value.

By default, Doc doc only branches out once.

Given a web site that has links like so:

`https://www.example.com` -> `https://www.example.com/page1` -> `https://www.example.com/page2` -> `https://www.example.com/page3`

Doc doc will check links on both `https://www.example.com` and `https://www.example.com/page1`, but not the other pages.

You can override the max amount of "spidering" with the `max-spidering` option. 

For example,

`$ doc_doc 'https://www.example.com' --crawl-within 'https://www.example.com' --max-spidering 2`

would also include `https://www.example.com/page2`, but not `https://www.example.com/page3`

There is currently no concept of a "unique page". If `https://www.example.com/page1` links back to `https://www.example.com` and `max-spidering` is set to 2 or higher, then sick links on `https://www.example.com` will be included twice. 


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/doc_doc. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Code of Conduct

Everyone interacting in the DocDoc project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/doc_doc/blob/master/CODE_OF_CONDUCT.md).
