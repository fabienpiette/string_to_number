#!/usr/bin/env ruby
# frozen_string_literal: true

# Profiling script to identify performance bottlenecks
# Requires ruby-prof gem: gem install ruby-prof

require_relative 'lib/string_to_number'

begin
  require 'ruby-prof'
  
  # Profile the most complex case
  test_input = 'soixante-quinze million trois cent quarante six mille sept cent quatre-vingt-dix neuf'
  
  puts "Profiling StringToNumber with input:"
  puts "'#{test_input}'"
  puts "=" * 80
  
  # Start profiling
  RubyProf.start
  
  # Run the conversion many times
  5000.times do
    StringToNumber.in_numbers(test_input)
  end
  
  # Stop profiling
  result = RubyProf.stop
  
  # Print results
  puts "\nTop 20 methods by total time:"
  puts "-" * 80
  
  printer = RubyProf::FlatPrinter.new(result)
  printer.print(STDOUT, min_percent: 1)
  
  # Generate call graph
  puts "\n\nCall Graph Analysis:"
  puts "-" * 80
  
  printer = RubyProf::CallTreePrinter.new(result)
  File.open('profile_output.txt', 'w') do |file|
    printer.print(file)
  end
  puts "Detailed call graph saved to: profile_output.txt"
  
  # Method-specific analysis
  puts "\n\nMethod Breakdown:"
  puts "-" * 80
  
  result.threads.each do |thread|
    thread.methods.sort_by(&:total_time).reverse.first(10).each do |method|
      next if method.total_time < 0.01
      
      puts "#{method.full_name}"
      puts "  Total time: #{(method.total_time * 1000).round(2)}ms"
      puts "  Calls: #{method.called}"
      puts "  Time per call: #{((method.total_time / method.called) * 1000).round(4)}ms"
      puts
    end
  end

rescue LoadError
  puts "ruby-prof gem not available. Running basic timing analysis instead."
  puts "Install with: gem install ruby-prof"
  puts
  
  # Fallback: manual timing analysis
  require 'benchmark'
  
  test_cases = [
    'un',
    'vingt et un', 
    'mille deux cent',
    'trois milliards cinq cents millions'
  ]
  
  puts "Manual Performance Analysis:"
  puts "=" * 40
  
  test_cases.each do |input|
    puts "\nAnalyzing: '#{input}'"
    
    # Time different aspects
    parser = nil
    init_time = Benchmark.realtime do
      1000.times { parser = StringToNumber::ToNumber.new(input) }
    end
    
    conversion_time = Benchmark.realtime do
      1000.times { parser.to_number }
    end
    
    total_time = Benchmark.realtime do
      1000.times { StringToNumber.in_numbers(input) }
    end
    
    puts "  Initialization: #{(init_time * 1000).round(4)}ms per 1000 calls"
    puts "  Conversion: #{(conversion_time * 1000).round(4)}ms per 1000 calls"
    puts "  Total: #{(total_time * 1000).round(4)}ms per 1000 calls"
    puts "  Complexity: #{input.split.size} words, #{input.length} characters"
  end

  # Test regex performance specifically
  puts "\n\nRegex Performance Test:"
  puts "=" * 40
  
  sample_input = "trois milliards cinq cents millions"
  parser = StringToNumber::ToNumber.new(sample_input)
  keys = parser.instance_variable_get(:@keys)
  
  puts "Keys pattern length: #{keys.length} characters"
  
  regex_time = Benchmark.realtime do
    10000.times do
      /(?<f>.*?)\s?(?<m>#{keys})/.match(sample_input)
    end
  end
  
  puts "Regex matching time: #{(regex_time * 100).round(4)}ms per 10000 matches"
  
  # Test hash lookup performance
  lookup_time = Benchmark.realtime do
    100000.times do
      StringToNumber::ToNumber::EXCEPTIONS['vingt']
      StringToNumber::ToNumber::POWERS_OF_TEN['millions']
    end
  end
  
  puts "Hash lookup time: #{(lookup_time * 10).round(4)}ms per 100000 lookups"
end