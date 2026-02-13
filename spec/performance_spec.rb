# frozen_string_literal: true

require 'spec_helper'
require 'benchmark'

# Test data sets for different complexity levels
SIMPLE_NUMBERS = %w[
  un deux trois quatre cinq six sept huit neuf dix
  vingt trente quarante cinquante soixante soixante-dix
  quatre-vingt quatre-vingt-dix cent
].freeze

MEDIUM_NUMBERS = [
  'vingt et un', 'trente-deux', 'quarante-trois', 'cinquante-quatre',
  'soixante-cinq', 'soixante-dix-sept', 'quatre-vingt-huit', 'quatre-vingt-dix-neuf',
  'cent un', 'deux cent cinquante', 'trois cent quarante-six',
  'neuf cent quatre-vingt-dix-neuf'
].freeze

COMPLEX_NUMBERS = [
  'mille deux cent trente-quatre',
  'vingt et un mille huit cent quatre-vingt deux',
  'trois cent quarante six mille sept cent quatre-vingt-dix neuf',
  'soixante-quinze million trois cent quarante six mille sept cent quatre-vingt-dix neuf',
  'un milliard deux cent millions',
  'trois milliards cinq cents millions'
].freeze

EDGE_CASES = [
  # Case variations
  'VINGT', 'Cent', 'MiLlE',
  # Regional variations
  'septante', 'huitante', 'nonante',
  # Feminine forms
  'une', 'vingt et une', 'trente et une',
  # Complex et usage
  'mille et un', 'deux cent et un',
  # Quatre-vingt variations
  'quatre-vingts', 'quatre vingts', 'quatre-vingts-dix'
].freeze

describe 'StringToNumber Performance Tests' do
  # Helper method to run performance benchmarks
  def benchmark_conversion(test_cases, description, iterations = 1000)
    puts "\n#{description}"
    puts '=' * 50
    puts "Test cases: #{test_cases.size}"
    puts "Iterations per case: #{iterations}"
    puts "Total conversions: #{test_cases.size * iterations}"

    # Warm up the JIT compiler if using JRuby
    test_cases.each { |text| StringToNumber.in_numbers(text) }

    total_time = Benchmark.realtime do
      test_cases.each do |text|
        iterations.times do
          StringToNumber.in_numbers(text)
        end
      end
    end

    total_conversions = test_cases.size * iterations
    avg_time_per_conversion = (total_time / total_conversions) * 1000 # in milliseconds
    conversions_per_second = total_conversions / total_time

    puts "Total time: #{total_time.round(4)} seconds"
    puts "Average time per conversion: #{avg_time_per_conversion.round(4)} ms"
    puts "Conversions per second: #{conversions_per_second.round(0)}"

    # Performance assertions (adjust thresholds as needed)
    expect(avg_time_per_conversion).to be < 1.0, 'Average conversion time should be under 1ms'
    expect(conversions_per_second).to be > 1000, 'Should handle at least 1000 conversions per second'

    {
      total_time: total_time,
      avg_time_ms: avg_time_per_conversion,
      conversions_per_second: conversions_per_second
    }
  end

  describe 'Basic Performance Benchmarks' do
    it 'performs well with simple numbers (0-100)' do
      benchmark_conversion(SIMPLE_NUMBERS, 'Simple Numbers (0-100)', 5000)
    end

    it 'performs well with medium complexity numbers (100-1000)' do
      benchmark_conversion(MEDIUM_NUMBERS, 'Medium Complexity Numbers (100-1000)', 2000)
    end

    it 'performs well with complex numbers (1000+)' do
      benchmark_conversion(COMPLEX_NUMBERS, 'Complex Numbers (1000+)', 1000)
    end

    it 'handles edge cases efficiently' do
      benchmark_conversion(EDGE_CASES, 'Edge Cases and Special Patterns', 2000)
    end
  end

  describe 'Scalability Tests' do
    it 'maintains performance with increased input length' do
      # Test how performance scales with input complexity
      short_input = 'vingt et un'
      medium_input = 'mille deux cent trente-quatre'
      long_input = 'soixante-quinze million trois cent quarante six mille sept cent quatre-vingt-dix neuf'
      very_long_input = 'trois milliards cinq cents millions deux cent mille et une'

      iterations = 2000

      results = []
      [short_input, medium_input, long_input, very_long_input].each_with_index do |input, _index|
        length = input.length
        puts "\nTesting input length: #{length} characters"
        puts "Input: '#{input}'"

        time = Benchmark.realtime do
          iterations.times { StringToNumber.in_numbers(input) }
        end

        avg_time = (time / iterations) * 1000
        results << { length: length, avg_time: avg_time }

        puts "Average time: #{avg_time.round(4)} ms"
      end

      # Check that performance doesn't degrade exponentially with input length
      # Allow for some increase but not more than 10x from shortest to longest
      shortest_time = results.first[:avg_time]
      longest_time = results.last[:avg_time]

      expect(longest_time / shortest_time).to be < 10,
                                              'Performance should not degrade more than 10x with input length'
    end

    it 'handles concurrent access efficiently' do
      # Test thread safety and concurrent performance
      skip 'Skipping concurrent test in single-threaded environment' if ENV['CI']

      threads = []
      results = []
      mutex = Mutex.new

      # Simulate concurrent access with multiple threads
      4.times do |i|
        threads << Thread.new do
          test_cases = SIMPLE_NUMBERS + MEDIUM_NUMBERS

          time = Benchmark.realtime do
            500.times do
              test_cases.each { |text| StringToNumber.in_numbers(text) }
            end
          end

          mutex.synchronize do
            results << { thread: i, time: time, conversions: test_cases.size * 500 }
          end
        end
      end

      threads.each(&:join)

      total_conversions = results.sum { |r| r[:conversions] }
      total_time = results.map { |r| r[:time] }.max # Use max time since threads run concurrently

      puts "\nConcurrent Performance Test:"
      puts "Threads: #{results.size}"
      puts "Total conversions: #{total_conversions}"
      puts "Total time: #{total_time.round(4)} seconds"
      puts "Conversions per second: #{(total_conversions / total_time).round(0)}"

      # Should still maintain decent performance under concurrent load
      expect(total_conversions / total_time).to be > 5000
    end
  end

  describe 'Memory Usage Tests' do
    it 'has reasonable memory footprint' do
      # Measure memory usage during intensive operations
      require 'objspace'

      # Force garbage collection before starting
      GC.start
      initial_objects = ObjectSpace.count_objects[:TOTAL]

      # Perform many conversions
      1000.times do
        COMPLEX_NUMBERS.each { |text| StringToNumber.in_numbers(text) }
      end

      # Force garbage collection after operations
      GC.start
      final_objects = ObjectSpace.count_objects[:TOTAL]

      object_growth = final_objects - initial_objects

      puts "\nMemory Usage Test:"
      puts "Initial objects: #{initial_objects}"
      puts "Final objects: #{final_objects}"
      puts "Object growth: #{object_growth}"

      # Should not create excessive temporary objects
      expect(object_growth).to be < 10_000, 'Should not create excessive temporary objects'
    end

    it 'cleans up temporary objects efficiently' do
      # Test that the parser doesn't leak memory over time
      initial_memory = `ps -o rss= -p #{Process.pid}`.to_i

      # Perform intensive operations
      5.times do
        1000.times do
          COMPLEX_NUMBERS.each { |text| StringToNumber.in_numbers(text) }
        end
        GC.start # Force cleanup between batches
      end

      final_memory = `ps -o rss= -p #{Process.pid}`.to_i
      memory_growth = final_memory - initial_memory

      puts "\nMemory Growth Test:"
      puts "Initial memory: #{initial_memory} KB"
      puts "Final memory: #{final_memory} KB"
      puts "Memory growth: #{memory_growth} KB"

      # Should not grow memory excessively (allow some growth for Ruby internals)
      expect(memory_growth).to be < 10_000, 'Memory growth should be minimal'
    end
  end

  describe 'Comparative Performance Analysis' do
    it 'compares performance across different number types' do
      test_groups = {
        'Direct lookups (EXCEPTIONS)' => %w[un vingt cent mille],
        'Simple compounds' => ['vingt et un', 'trente-deux', 'quarante-trois'],
        'Hundreds' => ['deux cent', 'trois cent cinquante', 'neuf cent quatre-vingt-dix-neuf'],
        'Thousands' => ['mille', 'deux mille', 'vingt mille', 'cent mille'],
        'Millions' => ['un million', 'cinq millions', 'cent millions'],
        'Complex compounds' => ['trois milliards cinq cents millions', 'soixante-quinze million trois cent quarante six mille']
      }

      results = {}
      iterations = 1000

      test_groups.each do |group_name, test_cases|
        StringToNumber.clear_caches!
        total_time = Benchmark.realtime do
          test_cases.each do |text|
            iterations.times { StringToNumber.in_numbers(text) }
          end
        end

        avg_time = (total_time / (test_cases.size * iterations)) * 1000
        results[group_name] = avg_time

        puts "\n#{group_name}: #{avg_time.round(4)} ms average"
      end

      # Verify that direct lookups are not significantly slower than complex parsing.
      # With caching, both groups converge to cache-hit speed, so allow a 3x margin
      # to avoid flaky failures on noisy CI runners.
      direct_lookup_time = results['Direct lookups (EXCEPTIONS)']
      complex_time = results['Complex compounds']

      expect(direct_lookup_time).to be < complex_time * 3,
                                    'Direct lookups should not be significantly slower than complex parsing'
    end
  end

  describe 'Regression Prevention' do
    it 'maintains baseline performance benchmarks' do
      # Establish baseline performance metrics that future changes shouldn't regress
      baseline_cases = [
        { input: 'vingt et un', max_time_ms: 0.1 },
        { input: 'mille deux cent trente-quatre', max_time_ms: 0.5 },
        { input: 'trois milliards cinq cents millions', max_time_ms: 1.0 }
      ]

      baseline_cases.each do |test_case|
        input = test_case[:input]
        max_time = test_case[:max_time_ms]

        time = Benchmark.realtime do
          1000.times { StringToNumber.in_numbers(input) }
        end

        avg_time_ms = (time / 1000) * 1000

        puts "\nBaseline Test - '#{input}'"
        puts "Average time: #{avg_time_ms.round(4)} ms (limit: #{max_time} ms)"

        expect(avg_time_ms).to be < max_time,
                               "Performance regression detected for '#{input}': #{avg_time_ms.round(4)}ms > #{max_time}ms"
      end
    end
  end
end
