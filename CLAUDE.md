# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Ruby gem that converts French words into numbers. The gem provides a single public method `StringToNumber.in_numbers(french_string)` that parses French number words and returns their numeric equivalent.

## Core Architecture

- **Main module**: `StringToNumber` in `lib/string_to_number.rb` - provides the public API
- **Optimized parser**: `StringToNumber::Parser` in `lib/string_to_number/parser.rb` - high-performance implementation
- **Original implementation**: `StringToNumber::ToNumber` in `lib/string_to_number/to_number.rb` - legacy compatibility
- **Version**: `StringToNumber::VERSION` in `lib/string_to_number/version.rb`

### Parser Architecture

The optimized parser uses:
- **WORD_VALUES**: Direct French word to number mappings (0-90, including regional variants)
- **MULTIPLIERS**: Power-of-ten multipliers (cent=2, mille=3, million=6, etc.)
- **Pre-compiled regex patterns**: Eliminate compilation overhead
- **Multi-level caching**: Instance cache + LRU conversion cache
- **Thread-safe design**: Concurrent access with mutex protection

The algorithm maintains the proven recursive parsing logic from the original while adding:
- Memoization for repeated conversions
- Instance caching to reduce initialization costs
- Optimized string operations and hash lookups

## Common Development Commands

```bash
# Install dependencies
bundle install

# Run tests
rake spec

# Run specific test
bundle exec rspec spec/string_to_number_spec.rb

# Start interactive console
rake console
# or
bundle exec irb -I lib -r string_to_number

# Install gem locally
bundle exec rake install

# Release new version (updates version.rb, creates git tag, pushes to rubygems)
bundle exec rake release
```

## Testing

Uses RSpec with comprehensive test coverage for French number parsing from 0 to millions. Tests are organized by number ranges (0-9, 10-19, 20-29, etc.) and include complex multi-word numbers.

### Performance Testing

Performance tests are available to measure and monitor the implementation's efficiency:

```bash
# Run comprehensive performance test suite
bundle exec rspec spec/performance_spec.rb

# Run standalone benchmark script
ruby -I lib benchmark.rb

# Run micro-benchmarks to identify bottlenecks
ruby -I lib microbenchmark.rb

# Run profiling analysis
ruby -I lib profile.rb
```

**Performance Characteristics (Optimized Implementation):**
- Simple numbers (0-100): ~0.001ms average, 800,000+ conversions/sec
- Medium complexity (100-1000): ~0.001ms average, 780,000+ conversions/sec  
- Complex numbers (1000+): ~0.002ms average, 690,000+ conversions/sec
- Exceptional scalability: minimal performance degradation with input length
- Memory efficient: zero object creation during operation
- Intelligent caching: repeated conversions benefit from memoization

**Performance Improvements:**
- **14-460x faster** than original implementation across all test cases
- **Excellent scalability**: 1.3x degradation vs 43x in original
- **Pre-compiled regex patterns** eliminate compilation overhead
- **Instance caching** reduces initialization costs
- **Memoization** speeds up repeated conversions
- **Thread-safe** with concurrent performance >2M conversions/sec

**Usage Options:**
```ruby
# Use optimized implementation (default)
StringToNumber.in_numbers('vingt et un')

# Use original implementation for compatibility
StringToNumber.in_numbers('vingt et un', use_optimized: false)

# Cache management
StringToNumber.clear_caches!
StringToNumber.cache_stats
```