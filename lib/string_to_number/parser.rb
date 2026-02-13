# frozen_string_literal: true

module StringToNumber
  # High-performance French text to number parser
  #
  # This class provides a clean, optimized implementation that maintains
  # compatibility with the original algorithm while adding significant
  # performance improvements through caching and memoization.
  #
  # @example Basic usage
  #   parser = StringToNumber::Parser.new
  #   parser.parse('vingt et un')  #=> 21
  #   parser.parse('trois millions') #=> 3_000_000
  #
  # @example Class method usage
  #   StringToNumber::Parser.convert('mille deux cent') #=> 1200
  #
  class Parser
    # Import the proven data structures from the original implementation
    WORD_VALUES = StringToNumber::ToNumber::EXCEPTIONS.freeze
    MULTIPLIERS = StringToNumber::ToNumber::POWERS_OF_TEN.freeze

    # Pre-compiled regex patterns for optimal performance
    MULTIPLIER_KEYS = MULTIPLIERS.keys
                                 .reject { |k| %w[un dix].include?(k) }
                                 .sort_by(&:length).reverse.freeze
    MULTIPLIER_PATTERN = /(?<f>.*?)\s?(?<m>#{MULTIPLIER_KEYS.join('|')})/.freeze
    QUATRE_VINGT_PATTERN = /(?<base>quatre[-\s]vingt(?:s?)(?:[-\s]dix)?)(?:[-\s]?)(?<suffix>\w*)/.freeze

    # Cache configuration
    MAX_CACHE_SIZE = 1000
    private_constant :MAX_CACHE_SIZE

    # Thread-safe LRU cache using Hash insertion order (Ruby 1.9+)
    @cache = {}
    @cache_hits = 0
    @cache_lookups = 0
    @cache_mutex = Mutex.new

    class << self
      # Convert French text to number using cached parser instance
      #
      # @param text [String] French number text to convert
      # @return [Integer] The numeric value
      # @raise [ArgumentError] if text is not a string
      def convert(text)
        validate_input!(text)

        normalized = normalize_text(text)
        return 0 if normalized.empty?

        @cache_mutex.synchronize do
          @cache_lookups += 1

          if @cache.key?(normalized)
            @cache_hits += 1
            # Delete and reinsert to move to end (most recently used)
            value = @cache.delete(normalized)
            @cache[normalized] = value
            return value
          end
        end

        result = new(normalized).parse_optimized(normalized)

        @cache_mutex.synchronize do
          @cache.delete(@cache.first[0]) if @cache.size >= MAX_CACHE_SIZE
          @cache[normalized] = result
        end

        result
      end

      # Clear all caches
      def clear_caches!
        @cache_mutex.synchronize do
          @cache.clear
          @cache_hits = 0
          @cache_lookups = 0
        end
      end

      # Get cache statistics
      def cache_stats
        @cache_mutex.synchronize do
          {
            conversion_cache_size: @cache.size,
            conversion_cache_limit: MAX_CACHE_SIZE,
            cache_hit_ratio: @cache_lookups.zero? ? 0.0 : @cache_hits.to_f / @cache_lookups
          }
        end
      end

      private

      def validate_input!(text)
        raise ArgumentError, 'Input must be a string' unless text.respond_to?(:to_s)
      end

      def normalize_text(text)
        text.to_s.downcase.strip
      end
    end

    # Initialize parser with normalized text
    def initialize(text = '')
      @normalized_text = self.class.send(:normalize_text, text)
    end

    # Parse the text to numeric value
    def parse
      self.class.convert(@normalized_text)
    end

    # Internal optimized parsing method using the original proven algorithm
    # but with performance optimizations
    def parse_optimized(text)
      return 0 if text.nil? || text.empty?

      # Direct lookup (fastest path)
      return WORD_VALUES[text] if WORD_VALUES.key?(text)

      # Use the proven extraction algorithm from the original implementation
      extract_optimized(text)
    end

    private

    # Optimized version of the original extract method
    # This maintains the exact logic of the working implementation
    # but with performance improvements
    def extract_optimized(sentence, detail: false)
      return 0 if sentence.nil? || sentence.empty?

      # Direct lookup
      return WORD_VALUES[sentence] if WORD_VALUES.key?(sentence)

      # Main pattern matching using pre-compiled regex
      if (result = MULTIPLIER_PATTERN.match(sentence))
        # Remove matched portion
        sentence = sentence.gsub(result[0], '') if result[0]

        # Extract factor
        factor = WORD_VALUES[result[:f]] || match_optimized(result[:f])
        factor = 1 if factor.zero? && !detail
        multiple_of_ten = 10**(MULTIPLIERS[result[:m]] || 0)

        # Handle compound numbers
        if higher_multiple_exists?(result[:m], sentence)
          details = extract_optimized(sentence, detail: true)
          factor = (factor * multiple_of_ten) + details[:factor]
          multiple_of_ten = details[:multiple_of_ten]
          sentence = details[:sentence]
        end

        # Return based on mode
        if detail
          return {
            factor: factor,
            multiple_of_ten: multiple_of_ten,
            sentence: sentence
          }
        end

        extract_optimized(sentence) + (factor * multiple_of_ten)

      # Quatre-vingt special handling
      elsif (m = QUATRE_VINGT_PATTERN.match(sentence))
        normalize_str = m[:base].tr(' ', '-')
        normalize_str = normalize_str[0...-1] if normalize_str[-1] == 's'

        sentence = sentence.gsub(m[0], '')

        extract_optimized(sentence) +
          WORD_VALUES[normalize_str] + (WORD_VALUES[m[:suffix]] || 0)
      else
        match_optimized(sentence)
      end
    end

    # Optimized match method
    def match_optimized(sentence)
      return 0 if sentence.nil?

      sentence.tr('-', ' ').split.reverse.sum do |word|
        next 0 if word == 'et'

        WORD_VALUES[word] || (MULTIPLIERS[word] ? 10 * MULTIPLIERS[word] : 0)
      end
    end

    # Optimized higher multiple check
    def higher_multiple_exists?(multiple, sentence)
      current_power = MULTIPLIERS[multiple]
      MULTIPLIERS.any? do |word, power|
        power > current_power && sentence.include?(word)
      end
    end
  end
end
