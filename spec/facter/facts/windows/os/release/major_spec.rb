# frozen_string_literal: true

describe 'Windows OsReleaseMajor' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'os.release.major', value: 'value')
      allow(WinOsReleaseResolver).to receive(:resolve).with(:major).and_return('value')
      allow(Facter::ResolvedFact).to receive(:new).with('os.release.major', 'value').and_return(expected_fact)

      fact = Facter::Windows::OsReleaseMajor.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
