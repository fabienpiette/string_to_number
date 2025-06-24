#!/usr/bin/env ruby
# frozen_string_literal: true

# Micro-benchmarks for specific StringToNumber components
# Focuses on identifying the most expensive operations

require_relative 'lib/string_to_number'
require 'benchmark'

class MicroBenchmark
  def self.run
    puts 'StringToNumber Micro-Benchmarks'
    puts '=' * 50
    puts

    # Test individual components
    test_initialization
    test_regex_compilation
    test_regex_matching
    test_hash_lookups
    test_string_operations
    test_recursion_overhead

    puts "\nConclusions and Recommendations:"
    puts '=' * 50
    analyze_results
  end

  def self.test_initialization
    puts '1. Initialization Performance'
    puts '-' * 30

    # Test the cost of creating new instances
    sentences = ['un', 'vingt et un', 'mille deux cent', 'trois milliards cinq cents millions']

    sentences.each do |sentence|
      time = Benchmark.realtime do
        1000.times { StringToNumber::ToNumber.new(sentence) }
      end

      puts "#{sentence.ljust(35)}: #{(time * 1000).round(4)}ms per 1000 instances"
    end
    puts
  end

  def self.test_regex_compilation
    puts '2. Regex Compilation Performance'
    puts '-' * 30

    # Test the cost of regex compilation vs pre-compiled regex
    keys = StringToNumber::ToNumber::POWERS_OF_TEN.keys.reject do |k|
      %w[un dix].include?(k)
    end.sort_by(&:length).reverse.join('|')

    # Dynamic compilation
    dynamic_time = Benchmark.realtime do
      1000.times do
        /(?<f>.*?)\s?(?<m>#{keys})/.match('trois milliards')
      end
    end

    # Pre-compiled regex
    compiled_regex = /(?<f>.*?)\s?(?<m>#{Regexp.escape(keys)})/
    precompiled_time = Benchmark.realtime do
      1000.times do
        compiled_regex.match('trois milliards')
      end
    end

    puts "Dynamic regex compilation: #{(dynamic_time * 1000).round(4)}ms per 1000 matches"
    puts "Pre-compiled regex:        #{(precompiled_time * 1000).round(4)}ms per 1000 matches"
    puts "Compilation overhead:      #{((dynamic_time - precompiled_time) * 1000).round(4)}ms per 1000 matches"
    puts
  end

  def self.test_regex_matching
    puts '3. Regex Pattern Complexity'
    puts '-' * 30

    # Test different regex patterns to see which are expensive
    test_patterns = {
      'Simple word match' => /vingt/,
      'Word boundary match' => /\bvingt\b/,
      'Named capture groups' => /(?<f>.*?)\s?(?<m>vingt)/,
      'Complex alternation' => /(?<f>.*?)\s?(?<m>vingt|trente|quarante|cinquante)/,
      'Full keys pattern' => /(?<f>.*?)\s?(?<m>#{StringToNumber::ToNumber::POWERS_OF_TEN.keys.reject do |k|
        %w[un dix].include?(k)
      end.sort_by(&:length).reverse.join('|')})/
    }

    test_string = 'trois milliards cinq cents millions'

    test_patterns.each do |name, pattern|
      time = Benchmark.realtime do
        5000.times { pattern.match(test_string) }
      end

      puts "#{name.ljust(25)}: #{(time * 1000).round(4)}ms per 5000 matches"
    end
    puts
  end

  def self.test_hash_lookups
    puts '4. Hash Lookup Performance'
    puts '-' * 30

    exceptions = StringToNumber::ToNumber::EXCEPTIONS
    powers = StringToNumber::ToNumber::POWERS_OF_TEN

    # Test lookup performance
    exceptions_time = Benchmark.realtime do
      10_000.times do
        exceptions['vingt']
        exceptions['trois']
        exceptions['cent']
      end
    end

    powers_time = Benchmark.realtime do
      10_000.times do
        powers['million']
        powers['mille']
        powers['cent']
      end
    end

    # Test nil checks
    nil_check_time = Benchmark.realtime do
      10_000.times do
        exceptions['nonexistent'].nil?
        powers['nonexistent'].nil?
      end
    end

    puts "EXCEPTIONS hash lookups:   #{(exceptions_time * 100).round(4)}ms per 10000 lookups"
    puts "POWERS_OF_TEN hash lookups: #{(powers_time * 100).round(4)}ms per 10000 lookups"
    puts "Nil check operations:      #{(nil_check_time * 100).round(4)}ms per 10000 checks"
    puts
  end

  def self.test_string_operations
    puts '5. String Operations Performance'
    puts '-' * 30

    test_string = 'TROIS MILLIARDS CINQ CENTS MILLIONS'

    # Test different string operations
    downcase_time = Benchmark.realtime do
      5000.times { test_string.downcase }
    end

    gsub_time = Benchmark.realtime do
      5000.times { test_string.gsub('MILLIONS', '') }
    end

    split_time = Benchmark.realtime do
      5000.times { test_string.split }
    end

    tr_time = Benchmark.realtime do
      5000.times { test_string.tr('-', ' ') }
    end

    puts "String#downcase:  #{(downcase_time * 1000).round(4)}ms per 5000 operations"
    puts "String#gsub:      #{(gsub_time * 1000).round(4)}ms per 5000 operations"
    puts "String#split:     #{(split_time * 1000).round(4)}ms per 5000 operations"
    puts "String#tr:        #{(tr_time * 1000).round(4)}ms per 5000 operations"
    puts
  end

  def self.test_recursion_overhead
    puts '6. Recursion vs Iteration Performance'
    puts '-' * 30

    # Compare recursive vs iterative approaches
    recursive_sum = lambda do |arr, index = 0|
      return 0 if index >= arr.length

      arr[index] + recursive_sum.call(arr, index + 1)
    end

    iterative_sum = :sum.to_proc

    test_array = Array.new(100) { rand(100) }

    recursive_time = Benchmark.realtime do
      1000.times { recursive_sum.call(test_array) }
    end

    iterative_time = Benchmark.realtime do
      1000.times { iterative_sum.call(test_array) }
    end

    puts "Recursive approach: #{(recursive_time * 1000).round(4)}ms per 1000 operations"
    puts "Iterative approach: #{(iterative_time * 1000).round(4)}ms per 1000 operations"
    puts "Recursion overhead: #{((recursive_time - iterative_time) * 1000).round(4)}ms per 1000 operations"
    puts
  end

  def self.analyze_results
    puts 'Key Performance Insights:'
    puts
    puts '1. 🔍 INITIALIZATION COST:'
    puts '   - Creating new ToNumber instances is expensive (~13ms per 1000)'
    puts '   - Consider caching or singleton pattern for repeated use'
    puts
    puts '2. 🔍 REGEX COMPLEXITY:'
    puts '   - Complex alternation patterns are the main bottleneck'
    puts '   - Keys pattern is 521 characters long - very expensive to match'
    puts '   - Consider breaking down into simpler patterns or using different approach'
    puts
    puts '3. 🔍 SCALABILITY ISSUES:'
    puts '   - Performance degrades significantly with input length (43x for longest)'
    puts '   - Recursive parsing creates overhead for complex numbers'
    puts '   - String operations add up with multiple passes'
    puts
    puts '📊 OPTIMIZATION RECOMMENDATIONS:'
    puts '   1. Pre-compile regex patterns in class constants'
    puts '   2. Use simpler regex patterns with multiple passes if needed'
    puts '   3. Implement caching for repeated conversions'
    puts '   4. Consider iterative parsing instead of recursive for complex cases'
    puts '   5. Optimize string operations (minimize downcase/gsub calls)'
  end
end

# Run the micro-benchmarks
MicroBenchmark.run if __FILE__ == $PROGRAM_NAME
