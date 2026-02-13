# frozen_string_literal: true

module StringToNumber
  # ToNumber class handles the conversion of French text to numbers
  # It uses a complex recursive parsing algorithm to handle French number grammar
  class ToNumber
    attr_accessor :sentence, :keys

    # EXCEPTIONS contains direct mappings from French words to their numeric values
    # This includes:
    # - Basic numbers 0-90
    # - Feminine forms ("une" for "un")
    # - Regional variations (Belgian/Swiss French: "septante", "huitante", "nonante")
    # - Special cases for "quatre-vingt" variations with/without 's'
    # - Compound numbers like "dix-sept", "soixante-dix"
    EXCEPTIONS = {
      'zéro' => 0,    # Zero with accent
      'zero' => 0,    # Zero without accent
      'un' => 1,      # Masculine "one"
      'une' => 1,     # Feminine "one"
      'deux' => 2,
      'trois' => 3,
      'quatre' => 4,
      'cinq' => 5,
      'six' => 6,
      'sept' => 7,
      'huit' => 8,
      'neuf' => 9,
      'dix' => 10,
      'onze' => 11,
      'douze' => 12,
      'treize' => 13,
      'quatorze' => 14,
      'quinze' => 15,
      'seize' => 16,
      'dix-sept' => 17,   # Compound: "ten-seven"
      'dix-huit' => 18,   # Compound: "ten-eight"
      'dix-neuf' => 19,   # Compound: "ten-nine"
      'vingt' => 20,
      'trente' => 30,
      'quarante' => 40,
      'cinquante' => 50,
      'soixante' => 60,
      'soixante-dix' => 70,     # Standard French: "sixty-ten"
      'septante' => 70,         # Belgian/Swiss French alternative
      'quatre-vingts' => 80,    # Standard French: "four-twenties" (plural)
      'quatre-vingt' => 80,     # Standard French: "four-twenty" (singular)
      'huitante' => 80,         # Swiss French alternative
      'quatre-vingt-dix' => 90, # Standard French: "four-twenty-ten"
      'quatre-vingts-dix' => 90, # Alternative with plural "vingts"
      'nonante' => 90 # Belgian/Swiss French alternative
    }.freeze

    # POWERS_OF_TEN maps French number words to their power of 10 exponents
    # Used for multipliers like "cent" (10^2), "mille" (10^3), "million" (10^6)
    # Includes both singular and plural forms for proper French grammar
    # Uses French number scale where "billion" = 10^12 (not 10^9 as in English)
    POWERS_OF_TEN = {
      'un' => 0,           # 10^0 = 1 (ones place)
      'dix' => 1,          # 10^1 = 10 (tens place)
      'cent' => 2,         # 10^2 = 100 (hundreds, singular)
      'cents' => 2,        # 10^2 = 100 (hundreds, plural)
      'mille' => 3,        # 10^3 = 1,000 (thousands, singular)
      'milles' => 3,       # 10^3 = 1,000 (thousands, plural)
      'million' => 6,      # 10^6 = 1,000,000 (millions, singular)
      'millions' => 6,     # 10^6 = 1,000,000 (millions, plural)
      'milliard' => 9,     # 10^9 = 1,000,000,000 (French billion, singular)
      'milliards' => 9,    # 10^9 = 1,000,000,000 (French billion, plural)
      'billion' => 12,     # 10^12 = 1,000,000,000,000 (French trillion, singular)
      'billions' => 12,    # 10^12 = 1,000,000,000,000 (French trillion, plural)
      'trillion' => 15,    # 10^15 (French quadrillion, singular)
      'trillions' => 15,   # 10^15 (French quadrillion, plural)
      # Extended list of large number names for completeness
      'quadrillion' => 15,
      'quintillion' => 18,
      'sextillion' => 21,
      'septillion' => 24,
      'octillion' => 27,
      'nonillion' => 30,
      'decillion' => 33,
      'undecillion' => 36,
      'duodecillion' => 39,
      'tredecillion' => 42,
      'quattuordecillion' => 45,
      'quindecillion' => 48,
      'sexdecillion' => 51,
      'septendecillion' => 54,
      'octodecillion' => 57,
      'novemdecillion' => 60,
      'vigintillion' => 63,
      'unvigintillion' => 66,
      'duovigintillion' => 69,
      'trevigintillion' => 72,
      'quattuorvigintillion' => 75,
      'quinvigintillion' => 78,
      'sexvigintillion' => 81,
      'septenvigintillion' => 84,
      'octovigintillion' => 87,
      'novemvigintillion' => 90,
      'trigintillion' => 93,
      'untrigintillion' => 96,
      'duotrigintillion' => 99,
      'googol' => 100 # Special case: 10^100
    }.freeze

    # Initialize the ToNumber parser with a French sentence
    # @param sentence [String] The French text to be converted to numbers
    def initialize(sentence = '')
      # Create regex pattern from POWERS_OF_TEN keys, excluding 'un' and 'dix'
      # which are handled differently in the parsing logic
      # Sort keys by length (longest first) to ensure longer matches are preferred
      # This prevents "cent" from matching before "cents" in "cinq cents"
      sorted_keys = POWERS_OF_TEN.keys.reject { |k| %w[un dix].include?(k) }.sort_by(&:length).reverse
      @keys = sorted_keys.join('|') # Create regex alternation pattern
      # Normalize input to lowercase for case-insensitive matching
      @sentence = sentence&.downcase || ''
    end

    # Main entry point to convert the French sentence to a number
    # @return [Integer] The numeric value of the French text
    def to_number
      extract(@sentence, keys)
    end

    private

    # Main recursive extraction method that parses French number patterns
    # This is the core of the parsing algorithm
    # @param sentence [String] The French text to parse
    # @param keys [String] Regex pattern of power-of-ten multipliers
    # @param detail [Boolean] If true, returns detailed parsing info for recursion
    # @return [Integer, Hash] Numeric value or detailed parsing hash
    def extract(sentence, keys, detail: false)
      # Base cases: handle empty/nil input
      return 0 if sentence.nil? || sentence.empty?

      # Ensure case-insensitive matching
      sentence = sentence.downcase

      # Direct lookup for simple cases (e.g., "vingt" -> 20)
      return EXCEPTIONS[sentence] unless EXCEPTIONS[sentence].nil?

      # Main parsing logic: look for pattern "factor + multiplier"
      # Example: "cinq cents" -> factor="cinq", multiplier="cents"
      # Regex explanation:
      #   (?<f>.*?) - Non-greedy capture of factor part (before multiplier)
      #   \s?       - Optional space
      #   (?<m>#{keys}) - Named capture of multiplier from keys pattern
      if (result = /(?<f>.*?)\s?(?<m>#{keys})/.match(sentence))
        # Remove the matched portion from sentence for further processing
        sentence.gsub!(::Regexp.last_match(0), '') if ::Regexp.last_match(0)

        # Parse the factor part (number before the multiplier)
        # Example: "cinq" -> 5, "deux cent" -> 200
        factor = EXCEPTIONS[result[:f]] || match(result[:f])

        # Handle implicit factor of 1 for standalone multipliers
        # Example: "million" -> factor=1, but only for top-level calls
        # For recursive calls (detail=true), keep factor as 0 to avoid double-counting
        factor = 1 if factor.zero? && !detail

        # Calculate the multiplier value (10^exponent)
        # Example: "cents" -> 10^2 = 100, "millions" -> 10^6 = 1,000,000
        multiple_of_ten = 10**(POWERS_OF_TEN[result[:m]] || 0)

        # Handle compound numbers with higher-order multipliers
        # Example: "cinq cents millions" - after matching "cinq cents",
        # check if "millions" (a higher multiplier than "cents") remains
        if /#{higher_multiple(result[:m]).keys.join('|')}/.match(sentence)
          # Recursively process the higher multiplier
          details = extract(sentence, keys, detail: true)

          # Combine the current factor*multiplier with the higher multiplier
          # Example: For "cinq cents millions":
          #   - factor = 5, multiple_of_ten = 100 (from "cinq cents")
          #   - details[:factor] = 0, details[:multiple_of_ten] = 1000000 (from "millions")
          #   - result: factor = (5 * 100) + 0 = 500, multiple_of_ten = 1000000
          #   - final: 500 * 1000000 = 500,000,000
          factor = (factor * multiple_of_ten) + details[:factor]
          multiple_of_ten = details[:multiple_of_ten]
          sentence = details[:sentence]
        end

        # Return detailed parsing info for recursive calls
        if detail
          return {
            factor: factor,
            multiple_of_ten: multiple_of_ten,
            sentence: sentence
          }
        end

        # Final calculation: process any remaining sentence + current factor*multiplier
        # Example: For "trois millions cinq cents", this handles the "cinq cents" part
        extract(sentence, keys) + (factor * multiple_of_ten)

      # Special case handling for "quatre-vingt" variations
      # This complex regex handles the irregular French "eighty" patterns:
      # - "quatre-vingt" / "quatre vingts" (with/without 's')
      # - "quatre-vingt-dix" / "quatre vingts dix" (90)
      # - Space vs hyphen variations
      elsif (m = /(?<base>quatre[-\s]vingt(?:s?)(?:[-\s]dix)?)(?:[-\s]?)(?<suffix>\w*)/.match(sentence))
        # Normalize spacing to hyphens for consistent lookup
        normalize_str = m[:base].tr(' ', '-')

        # Remove trailing 's' from "quatre-vingts" if present
        normalize_str = normalize_str[0...-1] if normalize_str[-1] == 's'

        # Remove the matched portion from sentence
        sentence.gsub!(m[0], '')

        # Return sum of: remaining sentence + normalized quatre-vingt value + any suffix
        # Example: "quatre-vingt-cinq" -> EXCEPTIONS["quatre-vingt"] + EXCEPTIONS["cinq"]
        extract(sentence, keys) +
          EXCEPTIONS[normalize_str] + (EXCEPTIONS[m[:suffix]] || 0)
      else
        # Fallback: use match() method for simple word combinations
        match(sentence)
      end
    end

    # Fallback method for parsing simple word sequences
    # Used when the main extract() method can't find multiplier patterns
    # @param sentence [String] French text to parse as individual words
    # @return [Integer, nil] Sum of individual word values or nil if no sentence
    def match(sentence)
      return if sentence.nil?

      # Process words in reverse order for proper French number logic
      # Example: "vingt et un" -> ["un", "et", "vingt"] -> 1 + 0 + 20 = 21
      sentence.downcase.tr('-', ' ').split.reverse.sum do |word|
        # Handle French "et" (and) conjunction by ignoring it in calculations
        # Example: "vingt et un" -> ignore "et", sum "vingt" + "un"
        next 0 if word == 'et'

        # Look up word value in either EXCEPTIONS or POWERS_OF_TEN
        if EXCEPTIONS[word].nil? && POWERS_OF_TEN[word].nil?
          # Unknown words contribute 0 to the sum
          0
        else
          # Use EXCEPTIONS value if available, otherwise use 10 * power_of_ten
          # Example: "dix" -> EXCEPTIONS["dix"] = 10
          #          "cent" -> 10 * POWERS_OF_TEN["cent"] = 10 * 2 = 100
          EXCEPTIONS[word] || (10 * POWERS_OF_TEN[word])
        end
      end
    end

    # Helper method to find multipliers with higher powers than the given one
    # Used to detect when compound numbers have higher-order multipliers
    # @param multiple [String] The current multiplier word (e.g., "cents")
    # @return [Hash] Hash of multipliers with higher powers of 10
    # Example: higher_multiple("cents") returns {"mille"=>3, "million"=>6, ...}
    #          because 10^3, 10^6, etc. are all > 10^2 (cents)
    def higher_multiple(multiple)
      POWERS_OF_TEN.select do |_k, v|
        v > POWERS_OF_TEN[multiple]
      end
    end
  end
end
