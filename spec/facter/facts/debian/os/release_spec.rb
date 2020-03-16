# frozen_string_literal: true

describe Facts::Debian::Os::Release do
  describe '#call_the_resolver' do
    subject(:fact) { Facts::Debian::Os::Release.new }

    let(:value) { '10.9' }
    let(:value_final) {  { 'full' => '10.9', 'major' => '10', 'minor' => '9' } }

    before do
      allow(Facter::Resolvers::LsbRelease).to receive(:resolve).with(:release).and_return(value)
    end

    it 'calls Facter::Resolvers::LsbRelease' do
      fact.call_the_resolver
      expect(Facter::Resolvers::LsbRelease).to have_received(:resolve).with(:release)
    end

    it 'returns release fact' do
      expect(fact.call_the_resolver).to be_an_instance_of(Array).and \
        contain_exactly(an_object_having_attributes(name: 'os.release', value: value_final),
                        an_object_having_attributes(name: 'operatingsystemmajrelease', value: value_final['major'],
                                                    type: :legacy),
                        an_object_having_attributes(name: 'operatingsystemrelease', value: value_final['full'],
                                                    type: :legacy))
    end
  end
end
