# frozen_string_literal: true

describe 'Sles facterversion' do
  context '#call_the_resolver' do
    let(:value) { '4.0.3' }
    subject(:fact) { Facter::Sles::Facterversion.new }

    before do
      allow(Facter::Resolvers::Facterversion).to receive(:resolve).with(:facterversion).and_return(value)
    end

    it 'calls Facter::Resolvers::Facterversion' do
      expect(Facter::Resolvers::Facterversion).to receive(:resolve).with(:facterversion)
      fact.call_the_resolver
    end

    it 'returns facterversion fact' do
      expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
        have_attributes(name: 'facterversion', value: value)
    end
  end
end
