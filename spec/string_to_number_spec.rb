# frozen_string_literal: true

require 'spec_helper'

describe StringToNumber do
  it 'has a version number' do
    expect(StringToNumber::VERSION).not_to be nil
  end

  it 'convert from one to nine' do
    expect(StringToNumber.in_numbers('zéro')).to eq(0)
    expect(StringToNumber.in_numbers('un')).to eq(1)
    expect(StringToNumber.in_numbers('deux')).to eq(2)
    expect(StringToNumber.in_numbers('trois')).to eq(3)
    expect(StringToNumber.in_numbers('quatre')).to eq(4)
    expect(StringToNumber.in_numbers('cinq')).to eq(5)
    expect(StringToNumber.in_numbers('six')).to eq(6)
    expect(StringToNumber.in_numbers('sept')).to eq(7)
    expect(StringToNumber.in_numbers('huit')).to eq(8)
    expect(StringToNumber.in_numbers('neuf')).to eq(9)
  end

  it 'convert from ten to nineteen' do
    expect(StringToNumber.in_numbers('dix')).to eq(10)
    expect(StringToNumber.in_numbers('onze')).to eq(11)
    expect(StringToNumber.in_numbers('douze')).to eq(12)
    expect(StringToNumber.in_numbers('treize')).to eq(13)
    expect(StringToNumber.in_numbers('quatorze')).to eq(14)
    expect(StringToNumber.in_numbers('quinze')).to eq(15)
    expect(StringToNumber.in_numbers('seize')).to eq(16)
    expect(StringToNumber.in_numbers('dix-sept')).to eq(17)
    expect(StringToNumber.in_numbers('dix-huit')).to eq(18)
    expect(StringToNumber.in_numbers('dix-neuf')).to eq(19)
  end

  it 'convert from twenty to twenty-nine' do
    expect(StringToNumber.in_numbers('vingt')).to eq(20)
    expect(StringToNumber.in_numbers('vingt et un')).to eq(21)
    expect(StringToNumber.in_numbers('vingt-deux')).to eq(22)
    expect(StringToNumber.in_numbers('vingt-trois')).to eq(23)
    expect(StringToNumber.in_numbers('vingt-quatre')).to eq(24)
    expect(StringToNumber.in_numbers('vingt-cinq')).to eq(25)
    expect(StringToNumber.in_numbers('vingt-six')).to eq(26)
    expect(StringToNumber.in_numbers('vingt-sept')).to eq(27)
    expect(StringToNumber.in_numbers('vingt-huit')).to eq(28)
    expect(StringToNumber.in_numbers('vingt-neuf')).to eq(29)
  end

  it 'convert from thirty to thirty-nine' do
    expect(StringToNumber.in_numbers('trente')).to eq(30)
    expect(StringToNumber.in_numbers('trente et un')).to eq(31)
    expect(StringToNumber.in_numbers('trente-deux')).to eq(32)
    expect(StringToNumber.in_numbers('trente-trois')).to eq(33)
    expect(StringToNumber.in_numbers('trente-quatre')).to eq(34)
    expect(StringToNumber.in_numbers('trente-cinq')).to eq(35)
    expect(StringToNumber.in_numbers('trente-six')).to eq(36)
    expect(StringToNumber.in_numbers('trente-sept')).to eq(37)
    expect(StringToNumber.in_numbers('trente-huit')).to eq(38)
    expect(StringToNumber.in_numbers('trente-neuf')).to eq(39)
  end

  it 'convert from forty to forty-nine' do
    expect(StringToNumber.in_numbers('quarante')).to eq(40)
    expect(StringToNumber.in_numbers('quarante et un')).to eq(41)
    expect(StringToNumber.in_numbers('quarante-deux')).to eq(42)
    expect(StringToNumber.in_numbers('quarante-trois')).to eq(43)
    expect(StringToNumber.in_numbers('quarante-quatre')).to eq(44)
    expect(StringToNumber.in_numbers('quarante-cinq')).to eq(45)
    expect(StringToNumber.in_numbers('quarante-six')).to eq(46)
    expect(StringToNumber.in_numbers('quarante-sept')).to eq(47)
    expect(StringToNumber.in_numbers('quarante-huit')).to eq(48)
    expect(StringToNumber.in_numbers('quarante-neuf')).to eq(49)
  end

  it 'convert from fifty to fifty-nine' do
    expect(StringToNumber.in_numbers('cinquante')).to eq(50)
    expect(StringToNumber.in_numbers('cinquante et un')).to eq(51)
    expect(StringToNumber.in_numbers('cinquante-deux')).to eq(52)
    expect(StringToNumber.in_numbers('cinquante-trois')).to eq(53)
    expect(StringToNumber.in_numbers('cinquante-quatre')).to eq(54)
    expect(StringToNumber.in_numbers('cinquante-cinq')).to eq(55)
    expect(StringToNumber.in_numbers('cinquante-six')).to eq(56)
    expect(StringToNumber.in_numbers('cinquante-sept')).to eq(57)
    expect(StringToNumber.in_numbers('cinquante-huit')).to eq(58)
    expect(StringToNumber.in_numbers('cinquante-neuf')).to eq(59)
  end

  it 'convert from sixty to sixty-nine' do
    expect(StringToNumber.in_numbers('soixante')).to eq(60)
    expect(StringToNumber.in_numbers('soixante et un')).to eq(61)
    expect(StringToNumber.in_numbers('soixante-deux')).to eq(62)
    expect(StringToNumber.in_numbers('soixante-trois')).to eq(63)
    expect(StringToNumber.in_numbers('soixante-quatre')).to eq(64)
    expect(StringToNumber.in_numbers('soixante-cinq')).to eq(65)
    expect(StringToNumber.in_numbers('soixante-six')).to eq(66)
    expect(StringToNumber.in_numbers('soixante-sept')).to eq(67)
    expect(StringToNumber.in_numbers('soixante-huit')).to eq(68)
    expect(StringToNumber.in_numbers('soixante-neuf')).to eq(69)
  end

  it 'convert from seventy to seventy-nine' do
    expect(StringToNumber.in_numbers('soixante-dix')).to eq(70)
    expect(StringToNumber.in_numbers('soixante et onze')).to eq(71)
    expect(StringToNumber.in_numbers('soixante-douze')).to eq(72)
    expect(StringToNumber.in_numbers('soixante-treize')).to eq(73)
    expect(StringToNumber.in_numbers('soixante-quatorze')).to eq(74)
    expect(StringToNumber.in_numbers('soixante-quinze')).to eq(75)
    expect(StringToNumber.in_numbers('soixante-seize')).to eq(76)
    expect(StringToNumber.in_numbers('soixante-dix-sept')).to eq(77)
    expect(StringToNumber.in_numbers('soixante-dix-huit')).to eq(78)
    expect(StringToNumber.in_numbers('soixante-dix-neuf')).to eq(79)
  end

  it 'convert from eighty to eighty-nine' do
    expect(StringToNumber.in_numbers('quatre-vingt')).to eq(80)
    expect(StringToNumber.in_numbers('quatre-vingt-un')).to eq(81)
    expect(StringToNumber.in_numbers('quatre-vingt-deux')).to eq(82)
    expect(StringToNumber.in_numbers('quatre-vingt-trois')).to eq(83)
    expect(StringToNumber.in_numbers('quatre-vingt-quatre')).to eq(84)
    expect(StringToNumber.in_numbers('quatre-vingt-cinq')).to eq(85)
    expect(StringToNumber.in_numbers('quatre-vingt-six')).to eq(86)
    expect(StringToNumber.in_numbers('quatre-vingt-sept')).to eq(87)
    expect(StringToNumber.in_numbers('quatre-vingt-huit')).to eq(88)
    expect(StringToNumber.in_numbers('quatre-vingt-neuf')).to eq(89)
  end

  it 'convert from ninety to ninety-nine' do
    expect(StringToNumber.in_numbers('quatre-vingt-dix')).to eq(90)
    expect(StringToNumber.in_numbers('quatre-vingt-onze')).to eq(91)
    expect(StringToNumber.in_numbers('quatre-vingt-douze')).to eq(92)
    expect(StringToNumber.in_numbers('quatre-vingt-treize')).to eq(93)
    expect(StringToNumber.in_numbers('quatre-vingt-quatorze')).to eq(94)
    expect(StringToNumber.in_numbers('quatre-vingt-quinze')).to eq(95)
    expect(StringToNumber.in_numbers('quatre-vingt-seize')).to eq(96)
    expect(StringToNumber.in_numbers('quatre-vingt-dix-sept')).to eq(97)
    expect(StringToNumber.in_numbers('quatre-vingt-dix-huit')).to eq(98)
    expect(StringToNumber.in_numbers('quatre-vingt-dix-neuf')).to eq(99)
  end

  it 'convert from one hundred to one hundred ninety nine' do
    expect(StringToNumber.in_numbers('cent')).to eq(100)
    expect(StringToNumber.in_numbers('cent un')).to eq(101)
    expect(StringToNumber.in_numbers('cent douze')).to eq(112)
    expect(StringToNumber.in_numbers('cent dix-neuf')).to eq(119)
    expect(StringToNumber.in_numbers('cent vingt-cinq')).to eq(125)
    expect(StringToNumber.in_numbers('cent soixante-sept')).to eq(167)
    expect(StringToNumber.in_numbers('cent soixante-dix')).to eq(170)
    expect(StringToNumber.in_numbers('cent soixante et onze')).to eq(171)
    expect(StringToNumber.in_numbers('cent quatre-vingt-sept')).to eq(187)
    expect(StringToNumber.in_numbers('cent quatre-vingt-dix-neuf')).to eq(199)
  end

  it 'convert from two hundred to nine hundred and ninety nine' do
    expect(StringToNumber.in_numbers('deux cent')).to eq(200)
    expect(StringToNumber.in_numbers('deux cent dix sept')).to eq(217)
    expect(StringToNumber.in_numbers('deux cent vingt deux')).to eq(222)
    expect(StringToNumber.in_numbers('deux cent soixante quatorze')).to eq(274)
    expect(StringToNumber.in_numbers('trois cent')).to eq(300)
    expect(StringToNumber.in_numbers('quatre cent')).to eq(400)
    expect(StringToNumber.in_numbers('neuf cent quatre vingt dix neuf')).to eq(999)
  end

  it 'convert from one thousand to one million' do
    expect(StringToNumber.in_numbers('mille')).to eq(1000)
    expect(StringToNumber.in_numbers('milles')).to eq(1000)
    expect(StringToNumber.in_numbers('mille cent onze')).to eq(1111)
    expect(StringToNumber.in_numbers('deux mille huit cent soixante-dix neuf')).to eq(2879)
    expect(StringToNumber.in_numbers('neuf mille neuf cent quatre-vingt-dix neuf')).to eq(9999)
    expect(StringToNumber.in_numbers('un million')).to eq(1_000_000)
  end

  it 'convert 34_551' do
    expect(
      StringToNumber.in_numbers(
        'trente-quatre mille cinq cent cinquante-et-un'
      )
    ).to eq(34_551)
  end

  it 'convert 21 882' do
    expect(
      StringToNumber.in_numbers(
        'vingt et un mille huit cent quatre-vingt deux'
      )
    ).to eq(21_882)
  end

  it 'convert 799' do
    expect(
      StringToNumber.in_numbers(
        'sept cent quatre-vingt-dix neuf'
      )
    ).to eq(799)
  end

  it 'convert 346 799' do
    expect(
      StringToNumber.in_numbers(
        'trois cent quarante six mille ' \
        'sept cent quatre-vingt-dix neuf'
      )
    ).to eq(346_799)
  end

  it 'convert 676 824' do
    expect(
      StringToNumber.in_numbers(
        'six cent soixante-seize mille ' \
        'huit cent vingt-quatre'
      )
    ).to eq(676_824)
  end

  it 'convert 75 346 799' do
    expect(
      StringToNumber.in_numbers(
        'soixante-quinze million ' \
        'trois cent quarante six mille ' \
        'sept cent quatre-vingt-dix neuf'
      )
    ).to eq(75_346_799)
  end

  describe 'edge cases and potential issues' do
    context 'case sensitivity' do
      it 'handles capitalized numbers' do
        expect(StringToNumber.in_numbers('Vingt')).to eq(20)
        expect(StringToNumber.in_numbers('CENT')).to eq(100)
        expect(StringToNumber.in_numbers('Mille')).to eq(1000)
      end
    end

    context 'feminine forms' do
      it 'handles feminine "une"' do
        expect(StringToNumber.in_numbers('une')).to eq(1)
        expect(StringToNumber.in_numbers('vingt et une')).to eq(21)
        expect(StringToNumber.in_numbers('trente et une')).to eq(31)
      end
    end

    context 'regional French variations' do
      it 'handles Belgian/Swiss French numbers' do
        expect(StringToNumber.in_numbers('septante')).to eq(70)
        expect(StringToNumber.in_numbers('huitante')).to eq(80)
        expect(StringToNumber.in_numbers('nonante')).to eq(90)
        expect(StringToNumber.in_numbers('septante-cinq')).to eq(75)
        expect(StringToNumber.in_numbers('nonante-neuf')).to eq(99)
      end
    end

    context 'French large number scale' do
      it 'handles milliard (French billion)' do
        expect(StringToNumber.in_numbers('un milliard')).to eq(1_000_000_000)
        expect(StringToNumber.in_numbers('deux milliards')).to eq(2_000_000_000)
        expect(StringToNumber.in_numbers('cinq cents millions')).to eq(500_000_000)
        expect(StringToNumber.in_numbers('trois milliards cinq cents millions')).to eq(3_500_000_000)
      end

      it 'handles billion as French trillion' do
        expect(StringToNumber.in_numbers('un billion')).to eq(1_000_000_000_000)
      end
    end

    context 'complex "et" conjunction usage' do
      it 'handles "et" with larger numbers' do
        expect(StringToNumber.in_numbers('mille et un')).to eq(1001)
        expect(StringToNumber.in_numbers('deux cent et un')).to eq(201)
        expect(StringToNumber.in_numbers('trois cent et un')).to eq(301)
        expect(StringToNumber.in_numbers('mille et une')).to eq(1001)
      end

      it 'handles hyphenated "et"' do
        expect(StringToNumber.in_numbers('vingt-et-un')).to eq(21)
        expect(StringToNumber.in_numbers('trente-et-un')).to eq(31)
        expect(StringToNumber.in_numbers('cinquante-et-un')).to eq(51)
      end
    end

    context 'quatre-vingts plural forms' do
      it 'handles quatre-vingts with s' do
        expect(StringToNumber.in_numbers('quatre-vingts')).to eq(80)
        expect(StringToNumber.in_numbers('quatre vingts')).to eq(80)
      end

      it 'handles quatre-vingt compounds correctly' do
        expect(StringToNumber.in_numbers('quatre-vingts-un')).to eq(81)
        expect(StringToNumber.in_numbers('quatre-vingts-dix')).to eq(90)
      end
    end

    context 'space vs hyphen variations' do
      it 'handles space-separated numbers' do
        expect(StringToNumber.in_numbers('vingt un')).to eq(21)
        expect(StringToNumber.in_numbers('trente quatre')).to eq(34)
        expect(StringToNumber.in_numbers('cinquante neuf')).to eq(59)
      end
    end

    context 'alternative spellings and forms' do
      it 'handles alternative number words' do
        expect(StringToNumber.in_numbers('zero')).to eq(0) # without accent
      end
    end

    context 'ordinal numbers' do
      it 'handles basic ordinal numbers' do
        pending 'Ordinal numbers not yet implemented'
        expect(StringToNumber.in_numbers('premier')).to eq(1)
        expect(StringToNumber.in_numbers('première')).to eq(1)
        expect(StringToNumber.in_numbers('deuxième')).to eq(2)
        expect(StringToNumber.in_numbers('troisième')).to eq(3)
        expect(StringToNumber.in_numbers('vingt-et-unième')).to eq(21)
      end
    end

    context 'error handling' do
      it 'handles empty and nil inputs' do
        expect(StringToNumber.in_numbers('')).to eq(0)
        expect(StringToNumber.in_numbers(nil)).to eq(0)
      end

      it 'handles invalid inputs gracefully' do
        expect(StringToNumber.in_numbers('invalid')).to eq(0)
        expect(StringToNumber.in_numbers('not a number')).to eq(0)
        expect(StringToNumber.in_numbers('123')).to eq(0) # numeric strings
      end
    end

    context 'mixed valid and invalid content' do
      it 'extracts numbers from mixed content' do
        expect(StringToNumber.in_numbers('vingt invalid')).to eq(20)
        expect(StringToNumber.in_numbers('invalid vingt')).to eq(20)
      end
    end
  end
end
