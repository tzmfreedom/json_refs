# JsonRefs

Dereference JSON reference with JSON Pointer.

'$refs' value is replaced with referenced value.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_refs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_refs

## Usage

```ruby
json = { 'a' => 'foo', 'b' => { '$ref' => '#/a' } }
JsonRefs.(json) # {"a"=>"foo", "b"=>"foo"}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tzmfreedom/json_refs.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).