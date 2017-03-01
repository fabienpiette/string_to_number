require "string_to_number/version"

module StringToNumber

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
    "vingt" => 20,
    "trente" => 30,
    "quarante" => 40,
    "cinquante" => 50,
    "soixante" => 60,
    "soixante-dix" => 70,
    "quatre-vingts" => 80,
    "quatre-vingt" => 80,
    "quatre-vingt-dix" => 90,
    "quatre-vingts-dix" => 90
  }

  POWERS_OF_TEN = {
    "un" => 0,
    "dix" => 1,
    "cent" => 2,
    "mille" => 3,
    "million" => 6,
    "billion" => 9,
    "trillion" => 12,
    "quadrillion" => 15,
    "quintillion" => 18,
    "sextillion" => 21,
    "septillion" => 24,
    "octillion" => 27,
    "nonillion" => 30,
    "decillion" => 33,
    "undecillion" => 36,
    "duodecillion" => 39,
    "tredecillion" => 42,
    "quattuordecillion" => 45,
    "quindecillion" => 48,
    "sexdecillion" => 51,
    "septendecillion" => 54,
    "octodecillion" => 57,
    "novemdecillion" => 60,
    "vigintillion" => 63,
    "unvigintillion" => 66,
    "duovigintillion" => 69,
    "trevigintillion" => 72,
    "quattuorvigintillion" => 75,
    "quinvigintillion" => 78,
    "sexvigintillion" => 81,
    "septenvigintillion" => 84,
    "octovigintillion" => 87,
    "novemvigintillion" => 90,
    "trigintillion" => 93,
    "untrigintillion" => 96,
    "duotrigintillion" => 99,
    "googol" => 100
  }

  class << self
    def in_numbers(sentence)
      StringToNumber.new(sentence).to_number
    end
  end

  def initialize(sentence = '')
    @keys = POWERS_OF_TEN.keys.reject{|k| %w(un dix).include?(k)}.join('|')
    @sentence = sentence
  end

  def to_number
    extract(@sentence, keys)
  end

  def extract(sentence, keys)
    return 0 if sentence.blank?
    return EXCEPTIONS[sentence] unless EXCEPTIONS[sentence].nil?

    if m = %r{(\w+)?\s?(#{keys})}.match(sentence)
      m1_length = if !EXCEPTIONS[m[1]].nil?
                    m[1].length
                  else
                    0
                  end

      sentence[m.offset(1)[0], m[1].length] = '' unless EXCEPTIONS[m[1]].nil?
      sentence[(m.offset(2)[0] - m1_length), m[2].length] = '' unless POWERS_OF_TEN[m[2]].nil?


      return extract(sentence, keys) +
               (EXCEPTIONS[m[1]] || 1) * (10 ** (POWERS_OF_TEN[m[2]] || 0))

    elsif m = %r{(quatre(-|\s)vingt(s?)((-|\s)dix)?)((-|\s)?)(\w*)}.match(sentence)
      normalize_str = m[1].gsub(' ','-')
      normalize_str = normalize_str[0...-1] if normalize_str.last == 's'

      return extract(sentence.gsub!(m[0],''), keys) +
               EXCEPTIONS[normalize_str] + (EXCEPTIONS[m[8]] || 0)
    else
      return match(sentence)
    end
  end

  def match(sentence)
    sentence.gsub('-', ' ').split(' ').reverse.inject(0) do |sum, word|
      if EXCEPTIONS[word].nil? && POWERS_OF_TEN[word].nil?
        sum += 0
      else
        sum += (EXCEPTIONS[word] || (10 * POWERS_OF_TEN[word]))
      end
    end
  end

end
