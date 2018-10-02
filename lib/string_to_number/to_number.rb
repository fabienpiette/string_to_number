# frozen_string_literal: true

module StringToNumber
  class ToNumber
    attr_accessor :sentence, :keys

    EXCEPTIONS = {
      'zéro' => 0,
      'zero' => 0,
      'un' => 1,
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
      'dix-sept' => 17,
      'dix-huit' => 18,
      'dix-neuf' => 19,
      'vingt' => 20,
      'trente' => 30,
      'quarante' => 40,
      'cinquante' => 50,
      'soixante' => 60,
      'soixante-dix' => 70,
      'quatre-vingts' => 80,
      'quatre-vingt' => 80,
      'quatre-vingt-dix' => 90,
      'quatre-vingts-dix' => 90
    }.freeze

    POWERS_OF_TEN = {
      'un' => 0,
      'dix' => 1,
      'cent' => 2,
      'mille' => 3,
      'million' => 6,
      'billion' => 9,
      'trillion' => 12,
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
      'googol' => 100
    }.freeze

    def initialize(sentence = '')
      @keys = POWERS_OF_TEN.keys.reject { |k| %w[un dix].include?(k) }.join('|')
      @sentence = sentence
    end

    def to_number
      extract(@sentence, keys)
    end

    private

    def extract(sentence, keys, detail: false)
      return 0 if sentence.nil? || sentence.empty?
      return EXCEPTIONS[sentence] unless EXCEPTIONS[sentence].nil?

      if result = /(?<f>.*?)\s?(?<m>#{keys})/.match(sentence)
        # Deleting matching element
        sentence.gsub!($&, '') if $&

        # Extract matching element
        factor          = EXCEPTIONS[result[:f]] || match(result[:f])
        factor          = 1 if factor.zero?
        multiple_of_ten = 10**(POWERS_OF_TEN[result[:m]] || 0)

        # Check if this multiple is over
        if /#{higher_multiple(result[:m]).keys.join('|')}/.match(sentence)
          details = extract(sentence, keys, detail: true)

          factor          = (factor * multiple_of_ten) + details[:factor]
          multiple_of_ten = details[:multiple_of_ten]
          sentence        = details[:sentence]
        end

        if detail
          return {
            factor: factor,
            multiple_of_ten: multiple_of_ten,
            sentence: sentence
          }
        end

        return extract(sentence, keys) + factor * multiple_of_ten

      elsif m = /(quatre(-|\s)vingt(s?)((-|\s)dix)?)((-|\s)?)(\w*)/.match(sentence)
        normalize_str = m[1].tr(' ', '-')
        normalize_str = normalize_str[0...-1] if normalize_str[normalize_str.length] == 's'

        sentence.gsub!(m[0], '')

        return extract(sentence, keys) +
               EXCEPTIONS[normalize_str] + (EXCEPTIONS[m[8]] || 0)
      else
        return match(sentence)
      end
    end

    def match(sentence)
      return if sentence.nil?

      sentence.tr('-', ' ').split(' ').reverse.sum do |word|
        if EXCEPTIONS[word].nil? && POWERS_OF_TEN[word].nil?
          0
        else
          (EXCEPTIONS[word] || (10 * POWERS_OF_TEN[word]))
        end
      end
    end

    def higher_multiple(multiple)
      POWERS_OF_TEN.select do |_k, v|
        v > POWERS_OF_TEN[multiple]
      end
    end
  end
end
