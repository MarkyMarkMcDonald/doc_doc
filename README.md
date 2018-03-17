# DocDoc

A Doc[tor] for your Doc[umentation]'s invalid links.


## Installation

```
$ gem install doc_doc
```


## Usage

```
$ doc_doc 'https://github.com/SeleniumHQ/selenium/wiki/Logging' --stay-within 'https://github.com/SeleniumHQ/selenium/wiki' > invalid_links.json
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

Doc Doc aims to find links that:
- lead to pages that do not load (http statuses in the 400 or 500 ranges)
- lead to pages without the elements referenced by the url fragment


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/doc_doc. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Code of Conduct

Everyone interacting in the DocDoc project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/doc_doc/blob/master/CODE_OF_CONDUCT.md).
