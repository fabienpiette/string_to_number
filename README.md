# StringToNumber

<p align="center">
  <a href="https://badge.fury.io/rb/string_to_number"><img src="https://badge.fury.io/rb/string_to_number.svg" alt="Gem Version"></a>
  <a href="https://github.com/FabienPiette/string_to_number/actions"><img src="https://github.com/FabienPiette/string_to_number/workflows/CI/badge.svg" alt="CI"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
</p>

Convert French written numbers into their numeric equivalents in Ruby.

<p align="center">
  <img src="docs/demo.gif" alt="goscribe demo" width="800">
</p>

## Quick Start

```ruby
gem 'string_to_number'  # Add to your Gemfile, then: bundle install
```

```ruby
require 'string_to_number'

StringToNumber.in_numbers('vingt et un')              #=> 21
StringToNumber.in_numbers('mille deux cent trente-quatre')  #=> 1234
StringToNumber.in_numbers('trois milliards')           #=> 3_000_000_000
```

## Features

- **Fast** — 14-460x faster than naive recursive parsing, via pre-compiled patterns and LRU caching
- **Complete** — handles all standard French number words from `zéro` to `billions`, including compound forms (`quatre-vingt-quatorze`, `soixante-dix`)
- **Thread-safe** — concurrent access with mutex-protected caches; >2M conversions/sec under contention
- **Zero dependencies** — pure Ruby, no external gems required

## Install

**Prerequisites:** Ruby 2.7+

```bash
gem install string_to_number
```

Or in your Gemfile:

```ruby
gem 'string_to_number'
```

## Usage

```ruby
require 'string_to_number'

# Simple numbers
StringToNumber.in_numbers('zéro')          #=> 0
StringToNumber.in_numbers('quinze')        #=> 15
StringToNumber.in_numbers('cent')          #=> 100

# Compound numbers
StringToNumber.in_numbers('vingt et un')                     #=> 21
StringToNumber.in_numbers('quatre-vingt-quatorze')           #=> 94
StringToNumber.in_numbers('neuf mille neuf cent quatre-vingt-dix-neuf')  #=> 9999

# Large numbers
StringToNumber.in_numbers('un million')          #=> 1_000_000
StringToNumber.in_numbers('deux millions trois cent mille')  #=> 2_300_000
```

### Validation and cache management

```ruby
StringToNumber.valid_french_number?('vingt et un')  #=> true
StringToNumber.valid_french_number?('hello world')  #=> false

StringToNumber.cache_stats    # inspect cache hit ratios
StringToNumber.clear_caches!  # free cached data
```

For the full API, see the [source documentation](lib/string_to_number.rb).

## Known Issues

- Input must be French number words only — mixed text (e.g. `"il y a vingt personnes"`) is not supported
- Regional Belgian/Swiss variants (`septante`, `nonante`) are recognized, but coverage may be incomplete

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/FabienPiette/string_to_number).

## Acknowledgments

Created by [Fabien Piette](https://github.com/FabienPiette). Thanks to all [contributors](https://github.com/FabienPiette/string_to_number/graphs/contributors).

<p align="center">
<a href="https://buymeacoffee.com/fabienpiette" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="60"></a>
</p>

## License

[MIT](LICENSE)
