#!/usr/bin/env ruby
# frozen_string_literal: true

# Performance benchmark script for StringToNumber gem
# Run with: ruby benchmark.rb

require_relative 'lib/string_to_number'
require 'benchmark'

class StringToNumberBenchmark
  # Test data organized by complexity
  TEST_CASES = {
    simple: %w[
      un vingt cent mille
    ],
    medium: [
      'vingt et un', 'deux cent cinquante', 'mille deux cent'
    ],
    complex: [
      'trois milliards cinq cents millions',
      'soixante-quinze million trois cent quarante six mille sept cent quatre-vingt-dix neuf'
    ],
    edge_cases: %w[
      VINGT une septante quatre-vingts
    ]
  }.freeze

  def self.run_benchmark
    puts 'StringToNumber Performance Benchmark'
    puts '=' * 50
    puts "Ruby version: #{RUBY_VERSION}"
    puts "Platform: #{RUBY_PLATFORM}"
    puts

    # Warm up
    puts 'Warming up...'
    TEST_CASES.values.flatten.each { |text| StringToNumber.in_numbers(text) }
    puts

    total_results = {}

    TEST_CASES.each do |category, test_cases|
      puts "#{category.to_s.capitalize} Numbers:"
      puts '-' * 30

      results = benchmark_category(test_cases)
      total_results[category] = results

      puts "Cases: #{test_cases.size}"
      puts "Total time: #{results[:total_time].round(4)}s"
      puts "Average per conversion: #{results[:avg_time_ms].round(4)}ms"
      puts "Conversions per second: #{results[:ops_per_sec].round(0)}"
      puts

      # Show individual case performance for complex numbers
      next unless category == :complex

      puts 'Individual case breakdown:'
      test_cases.each_with_index do |text, index|
        individual_time = Benchmark.realtime do
          1000.times { StringToNumber.in_numbers(text) }
        end
        avg_ms = (individual_time / 1000) * 1000
        puts "  #{index + 1}. #{avg_ms.round(4)}ms - '#{text[0..50]}#{'...' if text.length > 50}'"
      end
      puts
    end

    # Summary
    puts '=' * 50
    puts 'PERFORMANCE SUMMARY'
    puts '=' * 50

    total_results.each do |category, results|
      status = case results[:avg_time_ms]
               when 0..0.1 then '🟢 Excellent'
               when 0.1..0.5 then '🟡 Good'
               when 0.5..1.0 then '🟠 Acceptable'
               else '🔴 Needs optimization'
               end

      puts "#{category.to_s.capitalize.ljust(12)} #{status.ljust(15)} #{results[:avg_time_ms].round(4)}ms avg"
    end

    puts
    puts 'Memory efficiency test...'
    test_memory_usage

    puts
    puts 'Scalability test...'
    test_scalability
  end

  def self.benchmark_category(test_cases, iterations = 2000)
    total_time = Benchmark.realtime do
      test_cases.each do |text|
        iterations.times do
          StringToNumber.in_numbers(text)
        end
      end
    end

    total_conversions = test_cases.size * iterations
    avg_time_ms = (total_time / total_conversions) * 1000
    ops_per_sec = total_conversions / total_time

    {
      total_time: total_time,
      avg_time_ms: avg_time_ms,
      ops_per_sec: ops_per_sec
    }
  end

  def self.test_memory_usage
    # Test memory efficiency
    if Object.const_defined?(:ObjectSpace)
      GC.start
      initial_objects = ObjectSpace.count_objects[:TOTAL]

      # Perform intensive operations
      500.times do
        TEST_CASES.values.flatten.each { |text| StringToNumber.in_numbers(text) }
      end

      GC.start
      final_objects = ObjectSpace.count_objects[:TOTAL]
      object_growth = final_objects - initial_objects

      puts "Object creation: #{object_growth} new objects (#{object_growth > 1000 ? '🔴 High' : '🟢 Low'})"
    else
      puts 'Memory tracking not available on this platform'
    end
  end

  def self.test_scalability
    # Test how performance scales with input complexity
    inputs = [
      'un',                                                           # 2 chars
      'vingt et un',                                                  # 11 chars
      'mille deux cent trente-quatre',                               # 29 chars
      'trois milliards cinq cents millions deux cent mille et une'   # 58 chars
    ]

    puts 'Input length vs. performance:'

    results = inputs.map do |input|
      time = Benchmark.realtime do
        1000.times { StringToNumber.in_numbers(input) }
      end
      avg_ms = (time / 1000) * 1000

      { length: input.length, time: avg_ms, input: input }
    end

    results.each do |result|
      complexity_ratio = result[:time] / results.first[:time]
      status = if complexity_ratio < 5
                 '🟢'
               else
                 complexity_ratio < 10 ? '🟡' : '🔴'
               end

      puts "  #{result[:length].to_s.rjust(2)} chars: #{result[:time].round(4)}ms #{status} " \
           "(#{complexity_ratio.round(1)}x baseline)"
    end

    # Check if performance degrades reasonably
    worst_ratio = results.last[:time] / results.first[:time]
    if worst_ratio < 10
      puts "✅ Scalability: Good (#{worst_ratio.round(1)}x degradation)"
    else
      puts "❌ Scalability: Poor (#{worst_ratio.round(1)}x degradation)"
    end
  end
end

# Run the benchmark
StringToNumberBenchmark.run_benchmark if __FILE__ == $PROGRAM_NAME
