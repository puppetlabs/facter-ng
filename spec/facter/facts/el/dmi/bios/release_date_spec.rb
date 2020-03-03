# frozen_string_literal: true

describe Facts::El::Dmi::Bios::ReleaseDate do
  describe '#call_the_resolver' do
    subject(:fact) { Facts::El::Dmi::Bios::ReleaseDate.new }

    let(:date) { '07/03/2018' }

    before do
      allow(Facter::Resolvers::Linux::DmiBios).to \
        receive(:resolve).with(:bios_date).and_return(date)
    end

    it 'calls Facter::Resolvers::Linux::DmiBios' do
      fact.call_the_resolver
      expect(Facter::Resolvers::Linux::DmiBios).to have_received(:resolve).with(:bios_date)
    end

    it 'returns a resolved fact' do
      expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
        have_attributes(name: 'dmi.bios.release_date', value: date)
    end
  end
end
