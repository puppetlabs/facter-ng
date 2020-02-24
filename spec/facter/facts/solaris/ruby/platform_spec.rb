# frozen_string_literal: true

describe 'Solaris RubyPlatform' do
  describe '#call_the_resolver' do
    let(:value) { 'x86_64-linux' }
    subject(:fact) { Facter::Solaris::RubyPlatform.new }

    before do
      allow(Facter::Resolvers::Ruby).to receive(:resolve).with(:platform).and_return(value)
    end

    it 'calls Facter::Resolvers::Ruby' do
      expect(Facter::Resolvers::Ruby).to receive(:resolve).with(:platform).and_return(value)
      fact.call_the_resolver
    end

    it 'return ruby.platform fact' do
      expect(fact.call_the_resolver)
        .to be_an_instance_of(Facter::ResolvedFact)
        .and have_attributes(name: 'ruby.platform', value: value)
    end
  end
end
