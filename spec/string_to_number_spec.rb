require "spec_helper"

describe StringToNumberFr do
  it "has a version number" do
    expect(StringToNumberFr::VERSION).not_to be nil
  end

  it 'convert from one to nine' do
    expect(Language::Convert.new('zéro').to_number).to eq(0)
    expect(Language::Convert.new('un').to_number).to eq(1)
    expect(Language::Convert.new('deux').to_number).to eq(2)
    expect(Language::Convert.new('trois').to_number).to eq(3)
    expect(Language::Convert.new('quatre').to_number).to eq(4)
    expect(Language::Convert.new('cinq').to_number).to eq(5)
    expect(Language::Convert.new('six').to_number).to eq(6)
    expect(Language::Convert.new('sept').to_number).to eq(7)
    expect(Language::Convert.new('huit').to_number).to eq(8)
    expect(Language::Convert.new('neuf').to_number).to eq(9)
  end

  it 'convert from ten to nineteen' do
    expect(Language::Convert.new('dix').to_number).to eq(10)
    expect(Language::Convert.new('onze').to_number).to eq(11)
    expect(Language::Convert.new('douze').to_number).to eq(12)
    expect(Language::Convert.new('treize').to_number).to eq(13)
    expect(Language::Convert.new('quatorze').to_number).to eq(14)
    expect(Language::Convert.new('quinze').to_number).to eq(15)
    expect(Language::Convert.new('seize').to_number).to eq(16)
    expect(Language::Convert.new('dix-sept').to_number).to eq(17)
    expect(Language::Convert.new('dix-huit').to_number).to eq(18)
    expect(Language::Convert.new('dix-neuf').to_number).to eq(19)
  end

  it 'convert from twenty to twenty-nine' do
    expect(Language::Convert.new('vingt').to_number).to eq(20)
    expect(Language::Convert.new('vingt et un').to_number).to eq(21)
    expect(Language::Convert.new('vingt-deux').to_number).to eq(22)
    expect(Language::Convert.new('vingt-trois').to_number).to eq(23)
    expect(Language::Convert.new('vingt-quatre').to_number).to eq(24)
    expect(Language::Convert.new('vingt-cinq').to_number).to eq(25)
    expect(Language::Convert.new('vingt-six').to_number).to eq(26)
    expect(Language::Convert.new('vingt-sept').to_number).to eq(27)
    expect(Language::Convert.new('vingt-huit').to_number).to eq(28)
    expect(Language::Convert.new('vingt-neuf').to_number).to eq(29)
  end

  it 'convert from thirty to thirty-nine' do
    expect(Language::Convert.new('trente').to_number).to eq(30)
    expect(Language::Convert.new('trente et un').to_number).to eq(31)
    expect(Language::Convert.new('trente-deux').to_number).to eq(32)
    expect(Language::Convert.new('trente-trois').to_number).to eq(33)
    expect(Language::Convert.new('trente-quatre').to_number).to eq(34)
    expect(Language::Convert.new('trente-cinq').to_number).to eq(35)
    expect(Language::Convert.new('trente-six').to_number).to eq(36)
    expect(Language::Convert.new('trente-sept').to_number).to eq(37)
    expect(Language::Convert.new('trente-huit').to_number).to eq(38)
    expect(Language::Convert.new('trente-neuf').to_number).to eq(39)
  end

  it 'convert from forty to forty-nine' do
    expect(Language::Convert.new('quarante').to_number).to eq(40)
    expect(Language::Convert.new('quarante et un').to_number).to eq(41)
    expect(Language::Convert.new('quarante-deux').to_number).to eq(42)
    expect(Language::Convert.new('quarante-trois').to_number).to eq(43)
    expect(Language::Convert.new('quarante-quatre').to_number).to eq(44)
    expect(Language::Convert.new('quarante-cinq').to_number).to eq(45)
    expect(Language::Convert.new('quarante-six').to_number).to eq(46)
    expect(Language::Convert.new('quarante-sept').to_number).to eq(47)
    expect(Language::Convert.new('quarante-huit').to_number).to eq(48)
    expect(Language::Convert.new('quarante-neuf').to_number).to eq(49)
  end

  it 'convert from fifty to fifty-nine' do
    expect(Language::Convert.new('cinquante').to_number).to eq(50)
    expect(Language::Convert.new('cinquante et un').to_number).to eq(51)
    expect(Language::Convert.new('cinquante-deux').to_number).to eq(52)
    expect(Language::Convert.new('cinquante-trois').to_number).to eq(53)
    expect(Language::Convert.new('cinquante-quatre').to_number).to eq(54)
    expect(Language::Convert.new('cinquante-cinq').to_number).to eq(55)
    expect(Language::Convert.new('cinquante-six').to_number).to eq(56)
    expect(Language::Convert.new('cinquante-sept').to_number).to eq(57)
    expect(Language::Convert.new('cinquante-huit').to_number).to eq(58)
    expect(Language::Convert.new('cinquante-neuf').to_number).to eq(59)
  end

  it 'convert from sixty to sixty-nine' do
    expect(Language::Convert.new('soixante').to_number).to eq(60)
    expect(Language::Convert.new('soixante et un').to_number).to eq(61)
    expect(Language::Convert.new('soixante-deux').to_number).to eq(62)
    expect(Language::Convert.new('soixante-trois').to_number).to eq(63)
    expect(Language::Convert.new('soixante-quatre').to_number).to eq(64)
    expect(Language::Convert.new('soixante-cinq').to_number).to eq(65)
    expect(Language::Convert.new('soixante-six').to_number).to eq(66)
    expect(Language::Convert.new('soixante-sept').to_number).to eq(67)
    expect(Language::Convert.new('soixante-huit').to_number).to eq(68)
    expect(Language::Convert.new('soixante-neuf').to_number).to eq(69)
  end

  it 'convert from seventy to seventy-nine' do
    expect(Language::Convert.new('soixante-dix').to_number).to eq(70)
    expect(Language::Convert.new('soixante et onze').to_number).to eq(71)
    expect(Language::Convert.new('soixante-douze').to_number).to eq(72)
    expect(Language::Convert.new('soixante-treize').to_number).to eq(73)
    expect(Language::Convert.new('soixante-quatorze').to_number).to eq(74)
    expect(Language::Convert.new('soixante-quinze').to_number).to eq(75)
    expect(Language::Convert.new('soixante-seize').to_number).to eq(76)
    expect(Language::Convert.new('soixante-dix-sept').to_number).to eq(77)
    expect(Language::Convert.new('soixante-dix-huit').to_number).to eq(78)
    expect(Language::Convert.new('soixante-dix-neuf').to_number).to eq(79)
  end

  it 'convert from eighty to eighty-nine' do
    expect(Language::Convert.new('quatre-vingt').to_number).to eq(80)
    expect(Language::Convert.new('quatre-vingt-un').to_number).to eq(81)
    expect(Language::Convert.new('quatre-vingt-deux').to_number).to eq(82)
    expect(Language::Convert.new('quatre-vingt-trois').to_number).to eq(83)
    expect(Language::Convert.new('quatre-vingt-quatre').to_number).to eq(84)
    expect(Language::Convert.new('quatre-vingt-cinq').to_number).to eq(85)
    expect(Language::Convert.new('quatre-vingt-six').to_number).to eq(86)
    expect(Language::Convert.new('quatre-vingt-sept').to_number).to eq(87)
    expect(Language::Convert.new('quatre-vingt-huit').to_number).to eq(88)
    expect(Language::Convert.new('quatre-vingt-neuf').to_number).to eq(89)
  end

  it 'convert from ninety to ninety-nine' do
    expect(Language::Convert.new('quatre-vingt-dix').to_number).to eq(90)
    expect(Language::Convert.new('quatre-vingt-onze').to_number).to eq(91)
    expect(Language::Convert.new('quatre-vingt-douze').to_number).to eq(92)
    expect(Language::Convert.new('quatre-vingt-treize').to_number).to eq(93)
    expect(Language::Convert.new('quatre-vingt-quatorze').to_number).to eq(94)
    expect(Language::Convert.new('quatre-vingt-quinze').to_number).to eq(95)
    expect(Language::Convert.new('quatre-vingt-seize').to_number).to eq(96)
    expect(Language::Convert.new('quatre-vingt-dix-sept').to_number).to eq(97)
    expect(Language::Convert.new('quatre-vingt-dix-huit').to_number).to eq(98)
    expect(Language::Convert.new('quatre-vingt-dix-neuf').to_number).to eq(99)
  end

  it 'convert from one hundred to one hundred ninety nine' do
    expect(Language::Convert.new('cent').to_number).to eq(100)
    expect(Language::Convert.new('cent un').to_number).to eq(101)
    expect(Language::Convert.new('cent douze').to_number).to eq(112)
    expect(Language::Convert.new('cent dix-neuf').to_number).to eq(119)
    expect(Language::Convert.new('cent vingt-cinq').to_number).to eq(125)
    expect(Language::Convert.new('cent soixante-sept').to_number).to eq(167)
    expect(Language::Convert.new('cent soixante-dix').to_number).to eq(170)
    expect(Language::Convert.new('cent soixante et onze').to_number).to eq(171)
    expect(Language::Convert.new('cent quatre-vingt-sept').to_number).to eq(187)
    expect(Language::Convert.new('cent quatre-vingt-dix-neuf').to_number).to eq(199)
  end

  it 'convert from two hundred to nine hundred and ninety nine' do
    expect(Language::Convert.new('deux cent').to_number).to eq(200)
    expect(Language::Convert.new('deux cent dix sept').to_number).to eq(217)
    expect(Language::Convert.new('deux cent vingt deux').to_number).to eq(222)
    expect(Language::Convert.new('deux cent soixante quatorze').to_number).to eq(274)
    expect(Language::Convert.new('trois cent').to_number).to eq(300)
    expect(Language::Convert.new('quatre cent').to_number).to eq(400)
    expect(Language::Convert.new('neuf cent quatre vingt dix neuf').to_number).to eq(999)
  end

  it 'convert from one thousand to one million' do
    expect(Language::Convert.new('mille').to_number).to eq(1000)
    expect(Language::Convert.new('milles').to_number).to eq(1000)
    expect(Language::Convert.new('mille cent onze').to_number).to eq(1111)
    expect(Language::Convert.new('deux mille huit cent soixante-dix neuf').to_number).to eq(2879)
    expect(Language::Convert.new('neuf mille neuf cent quatre-vingt-dix neuf').to_number).to eq(9999)
    expect(Language::Convert.new('un million').to_number).to eq(1000000)
  end
end
