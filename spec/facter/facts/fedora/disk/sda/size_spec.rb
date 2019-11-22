# frozen_string_literal: true

describe 'Fedora DiskSdaSize' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'disk.sda.size', value: '1.0 KiB')
      allow(Facter::Resolvers::Linux::Disk).to receive(:resolve).with(:sda_size).and_return(1024)
      allow(Facter::ResolvedFact).to receive(:new).with('disk.sda.size', '1.0 KiB').and_return(expected_fact)
      expect(Facter::BytesToHumanReadable).to receive(:convert).with(1024).and_return('1.0 KiB')

      fact = Facter::Fedora::DiskSdaSize.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
