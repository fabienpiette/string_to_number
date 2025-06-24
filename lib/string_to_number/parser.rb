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
    MULTIPLIER_KEYS = MULTIPLIERS.keys.reject { |k| %w[un dix].include?(k) }
                                 .sort_by(&:length).reverse.freeze
    MULTIPLIER_PATTERN = /(?<f>.*?)\s?(?<m>#{MULTIPLIER_KEYS.join('|')})/.freeze
    QUATRE_VINGT_PATTERN = /(quatre(-|\s)vingt(s?)((-|\s)dix)?)((-|\s)?)(\w*)/.freeze

    # Cache configuration
    MAX_CACHE_SIZE = 1000
    private_constant :MAX_CACHE_SIZE

    # Thread-safe class-level caches
    @conversion_cache = {}
    @cache_access_order = []
    @instance_cache = {}
    @cache_mutex = Mutex.new
    @instance_mutex = Mutex.new

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

        # Check conversion cache first
        cached_result = get_cached_conversion(normalized)
        return cached_result if cached_result

        # Get or create parser instance and convert
        parser = get_cached_instance(normalized)
        result = parser.parse_optimized(normalized)

        # Cache the result
        cache_conversion(normalized, result)
        result
      end

      # Clear all caches
      def clear_caches!
        @cache_mutex.synchronize do
          @conversion_cache.clear
          @cache_access_order.clear
        end

        @instance_mutex.synchronize do
          @instance_cache.clear
        end
      end

      # Get cache statistics
      def cache_stats
        @cache_mutex.synchronize do
          {
            conversion_cache_size: @conversion_cache.size,
            conversion_cache_limit: MAX_CACHE_SIZE,
            instance_cache_size: @instance_cache.size,
            cache_hit_ratio: calculate_hit_ratio
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

      def get_cached_conversion(normalized_text)
        @cache_mutex.synchronize do
          if @conversion_cache.key?(normalized_text)
            # Update LRU order
            @cache_access_order.delete(normalized_text)
            @cache_access_order.push(normalized_text)
            return @conversion_cache[normalized_text]
          end
        end
        nil
      end

      def cache_conversion(normalized_text, result)
        @cache_mutex.synchronize do
          # LRU eviction
          if @conversion_cache.size >= MAX_CACHE_SIZE
            oldest = @cache_access_order.shift
            @conversion_cache.delete(oldest)
          end

          @conversion_cache[normalized_text] = result
          @cache_access_order.push(normalized_text)
        end
      end

      def get_cached_instance(normalized_text)
        @instance_mutex.synchronize do
          @instance_cache[normalized_text] ||= new(normalized_text)
        end
      end

      def calculate_hit_ratio
        return 0.0 if @cache_access_order.empty?

        @conversion_cache.size.to_f / @cache_access_order.size
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
      extract_optimized(text, MULTIPLIER_KEYS.join('|'))
    end

    private

    # Optimized version of the original extract method
    # This maintains the exact logic of the working implementation
    # but with performance improvements
    def extract_optimized(sentence, keys, detail: false)
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
          details = extract_optimized(sentence, keys, detail: true)
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

        extract_optimized(sentence, keys) + (factor * multiple_of_ten)

      # Quatre-vingt special handling
      elsif (m = QUATRE_VINGT_PATTERN.match(sentence))
        normalize_str = m[1].tr(' ', '-')
        normalize_str = normalize_str[0...-1] if normalize_str[-1] == 's'

        sentence = sentence.gsub(m[0], '')

        extract_optimized(sentence, keys) +
          WORD_VALUES[normalize_str] + (WORD_VALUES[m[8]] || 0)
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
