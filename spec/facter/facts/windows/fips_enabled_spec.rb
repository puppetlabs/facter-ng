# frozen_string_literal: true

describe 'Windows FipsEnabled' do
  describe '#call_the_resolver' do
    let(:value) { true }
    subject(:fact) { Facter::Windows::FipsEnabled.new }

    before do
      allow(Facter::Resolvers::Windows::Fips).to receive(:resolve).with(:fips_enabled).and_return(value)
    end

    it 'calls Facter::Windows::Resolvers::Fips' do
      expect(Facter::Resolvers::Windows::Fips).to receive(:resolve).with(:fips_enabled)
      fact.call_the_resolver
    end

    it 'returns true if fips enabled' do
      expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
        have_attributes(name: 'fips_enabled', value: true)
    end
  end
end
