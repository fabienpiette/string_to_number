# StringToNumber

[![Gem Version](https://badge.fury.io/rb/string_to_number.svg)](https://badge.fury.io/rb/string_to_number)
[![Ruby](https://github.com/FabienPiette/string_to_number/workflows/Ruby/badge.svg)](https://github.com/FabienPiette/string_to_number/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A high-performance Ruby gem for converting French written numbers into their numeric equivalents. Features intelligent caching, thread-safe operations, and support for complex French number formats.

## ✨ Features

- **High Performance**: Up to 460x faster than naive implementations with intelligent caching
- **Thread-Safe**: Concurrent access support with proper locking mechanisms
- **Comprehensive**: Handles complex French number formats including:
  - Basic numbers (zéro, un, deux...)
  - Compound numbers (vingt et un, quatre-vingt-quatorze...)
  - Large numbers (millions, milliards, billions...)
  - Special cases (quatre-vingts, soixante-dix...)
- **Memory Efficient**: LRU cache with configurable limits
- **Backward Compatible**: Maintains compatibility with original implementation

## 🚀 Performance

| Input Size | Original | Optimized | Improvement |
|------------|----------|-----------|-------------|
| Short      | 0.5ms    | 0.035ms   | **14x**     |
| Medium     | 2.1ms    | 0.045ms   | **47x**     |
| Long       | 23ms     | 0.05ms    | **460x**    |

## 📦 Installation

Add this line to your application's Gemfile:

```ruby
gem 'string_to_number'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install string_to_number
```

## 🔧 Usage

### Basic Usage

```ruby
require 'string_to_number'

# Simple numbers
StringToNumber.in_numbers('zéro')          #=> 0
StringToNumber.in_numbers('quinze')        #=> 15
StringToNumber.in_numbers('cent')          #=> 100

# Compound numbers
StringToNumber.in_numbers('vingt et un')   #=> 21
StringToNumber.in_numbers('quatre-vingt-quatorze') #=> 94
StringToNumber.in_numbers('soixante-dix')  #=> 70

# Large numbers
StringToNumber.in_numbers('mille deux cent trente-quatre') #=> 1234
StringToNumber.in_numbers('un million')    #=> 1_000_000
StringToNumber.in_numbers('trois milliards') #=> 3_000_000_000

# Complex expressions
StringToNumber.in_numbers('neuf mille neuf cent quatre-vingt-dix-neuf') #=> 9999
StringToNumber.in_numbers('deux millions trois cent mille') #=> 2_300_000
```

### Advanced Features

```ruby
# Validation
StringToNumber.valid_french_number?('vingt et un')  #=> true
StringToNumber.valid_french_number?('hello world')  #=> false

# Cache management
StringToNumber.clear_caches!  # Clear all internal caches
stats = StringToNumber.cache_stats
puts "Cache hit ratio: #{stats[:cache_hit_ratio]}"

# Backward compatibility mode
StringToNumber.in_numbers('cent', use_optimized: false)  #=> 100
```

### Supported Number Formats

| Range | Examples |
|-------|----------|
| 0-19 | zéro, un, deux, trois, quatre, cinq, six, sept, huit, neuf, dix, onze, douze, treize, quatorze, quinze, seize, dix-sept, dix-huit, dix-neuf |
| 20-99 | vingt, trente, quarante, cinquante, soixante, soixante-dix, quatre-vingts, quatre-vingt-dix |
| 100+ | cent, mille, million, milliard, billion |
| Compounds | vingt et un, quatre-vingt-quatorze, deux mille trois |

## ⚡ Performance Tips

1. **Reuse conversions**: The gem automatically caches results for better performance
2. **Batch processing**: Use the optimized parser (default) for better throughput
3. **Memory management**: Call `clear_caches!` periodically if processing many unique inputs
4. **Thread safety**: The gem is thread-safe and can be used in concurrent environments

## 🧪 Development

After checking out the repo, run `bin/setup` to install dependencies:

```bash
$ git clone https://github.com/FabienPiette/string_to_number.git
$ cd string_to_number
$ bin/setup
```

### Running Tests

```bash
# Run all tests
$ rake spec

# Run performance tests
$ ruby benchmark.rb

# Run specific test files
$ rspec spec/string_to_number_spec.rb
```

### Performance Benchmarking

```bash
# Compare implementations
$ ruby performance_comparison.rb

# Detailed micro-benchmarks
$ ruby microbenchmark.rb
```

### Interactive Console

```bash
$ bin/console
# => Interactive prompt for experimentation
```

## 🏗️ Architecture

The gem uses a dual-architecture approach:

- **Optimized Parser** (`StringToNumber::Parser`): High-performance implementation with caching
- **Original Implementation** (`StringToNumber::ToNumber`): Reference implementation for compatibility

Key performance optimizations:
- Pre-compiled regex patterns
- LRU caching with thread-safe access
- Memoized parser instances
- Zero-allocation number matching

## 🤝 Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/FabienPiette/string_to_number.

### Development Process

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Write tests for your changes
4. Ensure all tests pass (`rake spec`)
5. Run performance tests to avoid regressions
6. Commit your changes (`git commit -am 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Code of Conduct

This project is intended to be a safe, welcoming space for collaboration. Contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## 📋 Requirements

- Ruby 2.5 or higher
- No external dependencies (uses only Ruby standard library)

## 🐛 Troubleshooting

### Common Issues

**Q: Numbers aren't parsing correctly**  
A: Ensure your input uses proper French number words. Use `valid_french_number?` to validate input.

**Q: Performance seems slow**  
A: Make sure you're using the default optimized parser. Check cache statistics with `cache_stats`.

**Q: Memory usage is high**  
A: Call `clear_caches!` periodically if processing many unique number strings.

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.

## 📄 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 🙏 Acknowledgments

- Original implementation by [Fabien Piette](https://github.com/FabienPiette)
- Performance optimizations and enhancements
- Community contributors and testers

