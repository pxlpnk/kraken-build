# Kraken::Build

Important:
This Software contains absolutly no error handling and far by not enough tests!

## Installation

Add this line to your application's Gemfile:

    gem 'kraken-build'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kraken-build

## Usage

 `kraken-build config.yml`

### Sample config
<pre>
-
  repository : 'rails-project'
  username : 'kraken'
  password : '$uperSecret'
  host : "https://jenkins.host"
  port : '8080'
  token : '123456789'
  owner : 'pxlpnk'
</pre>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
