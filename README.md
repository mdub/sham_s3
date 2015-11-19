# ShamS3

ShamS3 is a fake version of S3, intended for use as a test stub.  

ShamS3 is implemented as a Rack app, and so can be run with any Rack
app-server.  Even better, it can be used with ShamRack or WebMock, for
in-processing stubbing of S3 calls.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sham_s3'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sham_s3

## Usage

Typical usage is:

```ruby
require 'sham_s3'
s3_sham = ShamS3.new

require 'sham_rack'
ShamRack.at("s3.amazonaws.com").mount(s3_sham)

require 'aws-sdk-resources'
s3 = Aws::S3::Resource.new
# ... do stuff with s3 ...
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mdub/sham_s3.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
