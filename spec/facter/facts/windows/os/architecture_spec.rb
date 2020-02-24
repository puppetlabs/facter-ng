# frozen_string_literal: true

describe 'Windows OsArchitecture' do
  describe '#call_the_resolver' do
    let(:value) { 'x64' }
    subject(:fact) { Facter::Windows::OsArchitecture.new }

    before do
      allow(Facter::Resolvers::HardwareArchitecture).to receive(:resolve).with(:architecture).and_return(value)
    end

    it 'calls Facter::Resolvers::HardwareArchitecture' do
      expect(Facter::Resolvers::HardwareArchitecture).to receive(:resolve).with(:architecture)
      fact.call_the_resolver
    end

    it 'returns architecture fact' do
      expect(fact.call_the_resolver).to be_an_instance_of(Array).and \
        contain_exactly(an_object_having_attributes(name: 'os.architecture', value: value),
                        an_object_having_attributes(name: 'architecture', value: value, type: :legacy))
    end
  end
end
