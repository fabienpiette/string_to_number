# frozen_string_literal: true

require 'string_to_number/version'

# Load original implementation first for constant definitions
require 'string_to_number/to_number'

# Then load optimized implementation
require 'string_to_number/parser'

module StringToNumber
  # Main interface for converting French text to numbers
  #
  # This module provides a simple interface to the high-performance French
  # number parser with backward compatibility options.
  #
  # @example Basic usage
  #   StringToNumber.in_numbers('vingt et un') #=> 21
  #   StringToNumber.in_numbers('trois millions') #=> 3_000_000
  #
  # @example Backward compatibility
  #   StringToNumber.in_numbers('cent', use_optimized: false) #=> 100
  #
  class << self
    # Convert French text to number
    #
    # @param sentence [String] French number text to convert
    # @param use_optimized [Boolean] Whether to use optimized parser (default: true)
    # @return [Integer] The numeric value
    # @raise [ArgumentError] if sentence is not convertible to string
    #
    # @example Standard usage
    #   in_numbers('vingt et un') #=> 21
    #
    # @example Using original implementation
    #   in_numbers('cent', use_optimized: false) #=> 100
    #
    def in_numbers(sentence, use_optimized: true)
      if use_optimized
        Parser.convert(sentence)
      else
        # Fallback to original implementation for compatibility testing
        ToNumber.new(sentence).to_number
      end
    end

    # Convert using original implementation (for compatibility testing)
    #
    # @param sentence [String] French text to convert
    # @return [Integer] The numeric value
    def in_numbers_original(sentence)
      ToNumber.new(sentence).to_number
    end

    # Clear all internal caches
    #
    # Useful for testing, memory management, or when processing
    # large volumes of unique inputs.
    #
    # @return [void]
    def clear_caches!
      Parser.clear_caches!
    end

    # Get cache performance statistics
    #
    # @return [Hash] Cache statistics including sizes and hit ratios
    # @example
    #   stats = StringToNumber.cache_stats
    #   puts "Cache hit ratio: #{stats[:cache_hit_ratio]}"
    #
    def cache_stats
      Parser.cache_stats
    end

    # Check if a string contains valid French number words
    #
    # @param text [String] Text to validate
    # @return [Boolean] true if text appears to contain French numbers
    #
    def valid_french_number?(text)
      return false unless text.respond_to?(:to_s)

      normalized = text.to_s.downcase.strip
      return false if normalized.empty?

      # Check if any words are recognized French number words
      words = normalized.tr('-', ' ').split(/\s+/)
      recognized_words = words.count do |word|
        word == 'et' ||
          Parser::WORD_VALUES.key?(word) ||
          Parser::MULTIPLIERS.key?(word)
      end

      # Require at least 50% recognized words for validation
      recognized_words.to_f / words.size >= 0.5
    end
  end
end
