# frozen_string_literal: true

describe 'BytesToHumanReadable' do
  context '#convert' do
    it 'returns nil if bytes variable is nil' do
      expect(Facter::BytesToHumanReadable.convert(nil)).to eql(nil)
    end
    it 'returns nil if bytes variable is nil' do
      expect(Facter::BytesToHumanReadable.convert(1048575.7)).to eql('1.0 MiB')
    end
    it 'returns bytes if bytes variable is less than 1024' do
      expect(Facter::BytesToHumanReadable.convert(1023)).to eql('1023 bytes')
    end
    it 'returns 1 Kib if bytes variable equals 1024' do
      expect(Facter::BytesToHumanReadable.convert(1024)).to eql('1.0 KiB')
    end
    it 'returns bytes if number exceeds etta bytes' do
      expect(Facter::BytesToHumanReadable.convert(3_296_472_651_763_232_323_235)).to eql('3296472651763232323235 bytes')
    end
  end
end
