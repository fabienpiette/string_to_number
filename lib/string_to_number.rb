require 'string_to_number/version'
require 'string_to_number/to_number'

module StringToNumber
  class << self
    def in_numbers(sentence)
      StringToNumber::ToNumber.new(sentence).to_number
    end
  end
end
