# Testable

Testable is an automated test micro-framework that provides a thin wrapper around [Watir](http://watir.com/) and [Capybara](http://teamcapybara.github.io/capybara/). Testable is based on many ideas from tools like [SitePrism](https://github.com/natritmeyer/site_prism) and [Watirsome](https://github.com/p0deje/watirsome), while also being a logical evolution of my own tool, [Tapestry](https://github.com/jeffnyman/tapestry).

An automated test framework provides a machine-executable abstraction around testing and encodes a set of guiding principles and heuristics for writing tests-as-code.

One of the obstacles to covering the gap between principles of testing and the practice of testing is the mechanics of writing tests. These mechanics are focused on abstractions. A lot of the practice of testing comes down to that: finding the right abstractions. Any automated test framework should be capable of consuming your preferred abstractions because ultimately your automation is simply a tool that supports testing, which means how the framework encourages tests to be expressed should have high fidelty with how human tests would be expressed.

Testable is built, as are all of my test-supporting tools, on the idea that automation should largely be small-footprint, low-fiction, and high-yield.

The code that a test-supporting micro-framework allows should be modular, promoting both high cohesion and low coupling, as well as promoting a single level of abstraction. These concepts together lead to lightweight design as well as support traits that make change affordable. That makes the automation code less expensive to maintain and easier to change. That, ultimately, has a positive impact on the cost of change but, more importantly, allows Testable to be fit within a cost of mistake model, where the goal is to get feedback as quickly as possible regarding when mistakes are made.

## Installation

To get the latest stable release, add this line to your application's Gemfile:

```ruby
gem 'testable'
```

To get the latest code:

```ruby
gem 'testable', git: 'https://github.com/jeffnyman/testable'
```

After doing one of the above, execute the following command:

    $ bundle

You can also install Testable just as you would any other gem:

    $ gem install testable

## Usage

Instructions coming soon.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec:all` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

The default `rake` command will run all tests as well as a RuboCop analysis.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/jeffnyman/testable](https://github.com/jeffnyman/testable). The testing ecosystem of Ruby is very large and this project is intended to be a welcoming arena for collaboration on yet another test-supporting tool.

Everyone interacting in the Testable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jeffnyman/testable/blob/master/CODE_OF_CONDUCT.md).

The Testable gem follows [semantic versioning](http://semver.org).

To contribute to Testable:

1. [Fork the project](http://gun.io/blog/how-to-github-fork-branch-and-pull-request/).
2. Create your feature branch. (`git checkout -b my-new-feature`)
3. Commit your changes. (`git commit -am 'new feature'`)
4. Push the branch. (`git push origin my-new-feature`)
5. Create a new [pull request](https://help.github.com/articles/using-pull-requests).

## Author

* [Jeff Nyman](http://testerstories.com)

## License

Testable is distributed under the [MIT](http://www.opensource.org/licenses/MIT) license.
See the [LICENSE](https://github.com/jeffnyman/testable/blob/master/LICENSE.md) file for details.
